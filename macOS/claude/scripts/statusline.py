#!/usr/bin/env python3
"""
Claude Code status line.

Reads session JSON on stdin, outputs a single-line status with:
  [<model>] <context bar> <pct>% | <elapsed> | <git branch>

Context usage comes from the payload's `context_window` block (exact). The
model-id heuristic is a fallback for older Claude Code versions only.

Caching:
  - Git branch cached per cwd for 10s (avoids subprocess on every turn)
  - Transcript parsed freshly each turn (cheap — reads tail of one JSONL file)

Exit fast. Total budget: <30ms on typical hardware.
"""

import json
import os
import subprocess
import sys
import time
from pathlib import Path


CACHE_DIR = Path.home() / ".claude" / "cache"
CACHE_DIR.mkdir(parents=True, exist_ok=True)

# ANSI colors
RESET = "\033[0m"
DIM = "\033[2m"
WHITE = "\033[97m"
GRAY = "\033[90m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
RED = "\033[31m"
CYAN = "\033[36m"
BLUE = "\033[34m"


def fallback_limit(model_id: str) -> int:
    """Guess the window from the model id.

    Only used on Claude Code versions that don't send a `context_window` block.
    Unreliable: a 1M session can report an id with no `[1m]` marker, which is
    how this used to render 189k/1M as a red 94%.
    """
    if "[1m]" in model_id or "1m" in model_id.lower():
        return 1_000_000
    return 200_000


def context_usage(session: dict) -> tuple[int, int]:
    """(tokens, limit), preferring the authoritative `context_window` block.

    Claude Code sends context_window.{total_input_tokens,context_window_size}.
    Both are exact — never infer either when they're present.
    """
    cw = session.get("context_window") or {}

    tokens = cw.get("total_input_tokens")
    if not isinstance(tokens, int):
        tokens = last_turn_tokens(session.get("transcript_path", ""))

    limit = cw.get("context_window_size")
    if not isinstance(limit, int) or limit <= 0:
        limit = fallback_limit(session.get("model", {}).get("id", ""))

    return tokens, limit


def last_turn_tokens(transcript_path: str) -> int:
    """Sum input+cache tokens from the last assistant message."""
    if not transcript_path:
        return 0
    p = Path(transcript_path)
    if not p.exists():
        return 0
    try:
        # Read tail efficiently — typical transcripts are small enough that
        # reading the whole file is fine, but for very large sessions we
        # could seek from the end. Keep it simple.
        with p.open("rb") as f:
            lines = f.readlines()
        for raw in reversed(lines):
            try:
                msg = json.loads(raw)
            except Exception:
                continue
            if msg.get("type") != "assistant":
                continue
            usage = msg.get("message", {}).get("usage") or {}
            if not usage:
                continue
            return (
                usage.get("input_tokens", 0)
                + usage.get("cache_creation_input_tokens", 0)
                + usage.get("cache_read_input_tokens", 0)
            )
    except Exception:
        pass
    return 0


def session_start(transcript_path: str) -> float:
    """Unix timestamp of the first message in the transcript."""
    if not transcript_path:
        return time.time()
    p = Path(transcript_path)
    if not p.exists():
        return time.time()
    try:
        with p.open("rb") as f:
            for raw in f:
                try:
                    msg = json.loads(raw)
                except Exception:
                    continue
                ts = msg.get("timestamp")
                if not ts:
                    continue
                # ISO 8601 with Z
                ts = ts.replace("Z", "+00:00")
                try:
                    from datetime import datetime
                    return datetime.fromisoformat(ts).timestamp()
                except Exception:
                    continue
    except Exception:
        pass
    return time.time()


def git_branch(cwd: str) -> str:
    """Cached git branch lookup (10s TTL)."""
    if not cwd:
        return ""
    cache_key = CACHE_DIR / f"branch_{abs(hash(cwd)) & 0xFFFFFFFF}.txt"
    if cache_key.exists() and (time.time() - cache_key.stat().st_mtime) < 10:
        return cache_key.read_text().strip()
    try:
        r = subprocess.run(
            ["git", "-C", cwd, "branch", "--show-current"],
            capture_output=True,
            text=True,
            timeout=0.5,
        )
        branch = r.stdout.strip() if r.returncode == 0 else ""
    except Exception:
        branch = ""
    try:
        cache_key.write_text(branch)
    except Exception:
        pass
    return branch


def git_worktree(cwd: str) -> str:
    """Basename of the worktree root, e.g. backend-PROD-3326."""
    try:
        r = subprocess.run(
            ["git", "-C", cwd, "--no-optional-locks", "rev-parse", "--show-toplevel"],
            capture_output=True,
            text=True,
            timeout=0.5,
        )
        return os.path.basename(r.stdout.strip()) if r.returncode == 0 else ""
    except Exception:
        return ""


FILLED_CELL = "▓"
EMPTY_CELL = "░"


def progress_bar(pct: int, color: str, width: int = 14) -> str:
    """Stipple bar: filled cells carry the threshold color, empties stay dim."""
    filled = int(round(pct / 100 * width))
    filled = max(0, min(width, filled))
    return (
        f"{color}{FILLED_CELL * filled}{RESET}"
        f"{DIM}{EMPTY_CELL * (width - filled)}{RESET}"
    )


def context_color(pct: int) -> str:
    if pct >= 85:
        return RED
    if pct >= 60:
        return YELLOW
    return GREEN


def format_elapsed(seconds: float) -> str:
    s = int(seconds)
    if s < 60:
        return f"{s}s"
    m, s = divmod(s, 60)
    if m < 60:
        return f"{m}m"
    h, m = divmod(m, 60)
    return f"{h}h{m:02d}m"


def main() -> int:
    try:
        session = json.load(sys.stdin)
    except Exception:
        # If stdin is empty or malformed, print minimal line and exit clean
        print(f"{DIM}claude{RESET}")
        return 0

    model = session.get("model", {})
    model_id = model.get("id", "")
    model_name = model.get("display_name") or model_id or "claude"
    cwd = session.get("cwd") or session.get("workspace", {}).get("current_dir", "")
    transcript = session.get("transcript_path", "")

    tokens, limit = context_usage(session)
    pct = min(100, round(tokens / limit * 100)) if limit else 0
    color = context_color(pct)

    start = session_start(transcript)
    elapsed = format_elapsed(time.time() - start)

    branch = git_branch(cwd)

    parts = [
        f"{WHITE}[{model_name}]{RESET} {progress_bar(pct, color)} {color}{pct}%{RESET}",
        f"{CYAN}{elapsed}{RESET}",
    ]
    if branch:
        worktree = git_worktree(cwd)
        label = f"{branch} · {worktree}" if worktree else branch
        parts.append(f"{GRAY}{label}{RESET}")

    sep = f" {DIM}│{RESET} "
    print(sep.join(parts))
    return 0


if __name__ == "__main__":
    sys.exit(main())

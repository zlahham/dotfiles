-- =====================================================================
--                     Zaid's neovim config (Lua, modular)
-- =====================================================================
-- Author: Zaid Al Lahham [http://zaidlahham.me]
-- Source: https://github.com/zlahham/dotfiles
--
-- Layout:
--   init.lua              -- this file: leader, options, autocmds, core maps, lazy bootstrap
--   lua/plugins/ui.lua    -- colorscheme, statusline, treesitter, icons
--   lua/plugins/editor.lua-- finder, tree, git, surround, pairs
--   lua/plugins/lsp.lua   -- mason, LSP, completion, format, lint
--   lua/plugins/ruby.lua  -- rails, tests
--
-- Plugin *keymaps* live next to their plugin (lazy `keys=`); only the
-- plugin-agnostic maps live in this file.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- 1. Leader keys  (must be set BEFORE lazy loads)
-- ---------------------------------------------------------------------
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- ---------------------------------------------------------------------
-- 2. Options
-- ---------------------------------------------------------------------
local opt = vim.opt

opt.spelllang = "en_gb"
opt.showmatch = true
opt.ignorecase = true
opt.smartcase = true
opt.tabstop = 2
opt.softtabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.list = true
opt.number = true
opt.relativenumber = true
opt.showtabline = 2
opt.termguicolors = true       -- required by tokyonight & friends
opt.cursorline = true
opt.swapfile = false
opt.backup = false
opt.undofile = true            -- persistent undo across sessions (sensible default)
opt.scrolloff = 7
opt.clipboard = "unnamed"
opt.splitbelow = true
opt.splitright = true
opt.foldmethod = "indent"
opt.foldlevelstart = 99
opt.signcolumn = "yes"         -- always show gutter (gitsigns/diagnostics, no jitter)
opt.updatetime = 250           -- snappier CursorHold / gitsigns

-- ---------------------------------------------------------------------
-- 3. Native autocmds  (replace plugins with a few lines of config)
-- ---------------------------------------------------------------------
-- Trailing whitespace: trim on save + highlight (was vim-better-whitespace).
-- Only acts on real, editable file buffers — never neo-tree, terminals, help,
-- prompts, etc. (those have a non-empty 'buftype').
local ws = vim.api.nvim_create_augroup("TrailingWhitespace", { clear = true })

local function is_real_file()
  return vim.bo.buftype == "" and vim.bo.filetype ~= ""
end

-- Remove only OUR matches in the current window (never touch other plugins').
local function clear_ws_match()
  for _, m in ipairs(vim.fn.getmatches()) do
    if m.group == "TrailingWhitespace" then
      vim.fn.matchdelete(m.id)
    end
  end
end

vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#ff5555" })

-- Trim on save (real files only).
vim.api.nvim_create_autocmd("BufWritePre", {
  group = ws,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then return end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- Highlight, guarded + de-duplicated (clear ours first so matches don't stack).
vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType", "InsertLeave" }, {
  group = ws,
  callback = function()
    clear_ws_match()
    if is_real_file() then
      vim.fn.matchadd("TrailingWhitespace", [[\s\+$]])
    end
  end,
})
-- Hide while typing so it doesn't flag the space you're about to fill.
vim.api.nvim_create_autocmd("InsertEnter", {
  group = ws,
  callback = clear_ws_match,
})

-- Briefly highlight yanked text (nice sensible default)
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
})

-- ---------------------------------------------------------------------
-- 4. Core keymaps  (plugin-agnostic; plugin maps live in their specs)
-- ---------------------------------------------------------------------
local map = vim.keymap.set

-- Terminal: <Esc> leaves terminal-insert mode
map("t", "<Esc>", [[<C-\><C-n>]])

-- First non-blank with 0
map("n", "0", "^", { remap = true })

-- Toggle relative numbers
map("n", "<C-n>", ":set rnu!<CR>", { silent = true })

-- Move between splits
map("", "<C-h>", "<C-W>h")
map("", "<C-j>", "<C-W>j")
map("", "<C-k>", "<C-W>k")
map("", "<C-l>", "<C-w>l")

-- Exit insert mode with jk / kj
map("i", "jk", "<esc>")
map("i", "kj", "<esc>")

-- Move by visual (wrapped) lines
map("n", "j", "gj", { remap = true })
map("n", "k", "gk", { remap = true })

-- Count occurrences of word under cursor
map("", "<leader>#", "#<C-O>:%s///gn<CR>")
-- Clear search highlight
map("", "<leader><CR>", ":noh<CR>", { silent = true })

-- Tabs
map("", "<leader>tn", ":tabnew<cr>")
map("", "<leader>to", ":tabonly<cr>")
map("", "<leader>tc", ":tabclose<cr>")
map("", "<leader>tm", ":tabmove<CR>")
map("", "<leader>te", ':tabedit <c-r>=expand("%:p:h")<cr>/')
map("n", "<Space>", "gt")

-- Comment toggle via neovim's built-in commenting (gcc/gc are mappings -> remap)
map("n", "//", "gcc", { remap = true })
map("x", "//", "gc", { remap = true })

-- Insert a blank line without leaving normal mode
map("n", "<Leader>o", "o<Esc>")
map("n", "<Leader>O", "O<Esc>")

-- Diagnostics (LSP): jump + view
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- ---------------------------------------------------------------------
-- 5. Bootstrap lazy.nvim + load lua/plugins/*.lua
-- ---------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "plugins" },
}, {
  change_detection = { notify = false },
})

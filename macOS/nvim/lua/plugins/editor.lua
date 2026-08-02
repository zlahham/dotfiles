-- Editor: fuzzy finder, file tree, git, surround, pairs
return {
  -- Fuzzy finder (replaces fzf.vim).
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    -- Persist query history to disk, one file per picker. Inside any picker,
    -- <C-p>/<C-n> then walk previous/next past queries — and it survives
    -- restarts, so a search you ran before is one keystroke away, not a retype.
    init = function()
      vim.g.fzf_history_dir = vim.fn.stdpath("data") .. "/fzf-history"
    end,
    keys = {
      -- Files: tracked AND untracked (fd respects .gitignore, so no node_modules
      -- noise). Inside the picker, <C-g> toggles ignored files on/off.
      { "<C-p>", function() require("fzf-lua").files() end, desc = "Find files" },
      -- Everything, including gitignored + hidden files.
      {
        "<leader>F",
        function() require("fzf-lua").files({ no_ignore = true, hidden = true }) end,
        desc = "Find files (incl. ignored/hidden)",
      },
      -- Live grep that RESUMES: reopens with the last query + results, since
      -- fzf-lua closes the picker whenever you open a result (e.g. <C-t> = new
      -- tab). So tabbing to a match is never a dead end — `\` picks the search
      -- right back up. To start a fresh search, <C-u> clears the query first;
      -- <C-p>/<C-n> walk older queries.
      { "\\", function() require("fzf-lua").live_grep({ resume = true }) end, desc = "Live grep (resume)" },
      { "<leader>b", function() require("fzf-lua").buffers() end, desc = "Buffers" },
    },
    opts = function()
      return {
        -- --history rebinds fzf's <C-p>/<C-n> to query history; keep list
        -- navigation on <C-j>/<C-k> (the arrow keys still work too).
        keymap = { fzf = { ["ctrl-j"] = "down", ["ctrl-k"] = "up" } },
        grep = {
          -- Sort matches by file path (app/… before spec/…), like the
          -- filetree. --sort=path forces rg single-threaded — fine here.
          rg_opts = "--column --line-number --no-heading --color=always --smart-case "
            .. "--max-columns=4096 --sort=path -e",
        },
        files = {
          -- <C-g> inside the files picker toggles .gitignore on/off live
          actions = { ["ctrl-g"] = require("fzf-lua").actions.toggle_ignore },
        },
      }
    end,
  },

  -- File tree (replaces NERDTree). <Tab> toggles, <Leader><Tab> reveals.
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    keys = {
      { "<Tab>", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
      {
        "<Leader><Tab>",
        function() require("neo-tree.command").execute({ reveal = true }) end,
        desc = "Reveal current file in tree",
      },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = false },
      },
    },
  },

  -- Git diff signs in the gutter (replaces vim-gitgutter)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- Git commands (kept — nothing beats fugitive)
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gblame" },
  },

  -- Surround (replaces vim-surround)
  {
    "kylechui/nvim-surround",
    version = "^4.0.0",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto-pairs (replaces auto-pairs). Works hook-free with blink.cmp.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Seamless split/pane navigation: <C-h/j/k/l> moves between nvim splits AND
  -- tmux panes transparently (needs the matching tmux-side plugin in
  -- .tmux.conf). Replaces the plain <C-W>hjkl maps that used to live in
  -- init.lua. In tmux, use <prefix> C-l to clear the screen (C-l is nav now).
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight" },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Nav split/pane left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Nav split/pane down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Nav split/pane up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Nav split/pane right" },
    },
  },
}

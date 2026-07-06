-- Editor: fuzzy finder, file tree, git, surround, pairs
return {
  -- Fuzzy finder (replaces fzf.vim).
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
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
      { "\\", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
      { "<leader>b", function() require("fzf-lua").buffers() end, desc = "Buffers" },
    },
    opts = function()
      return {
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
}

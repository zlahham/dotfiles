-- Editor: fuzzy finder, file tree, git, surround, pairs
return {
  -- Fuzzy finder (replaces fzf.vim). git_files falls back to files outside a repo.
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      {
        "<C-p>",
        function()
          local fzf = require("fzf-lua")
          if vim.fn.isdirectory(".git") == 1 or vim.fn.finddir(".git", ".;") ~= "" then
            fzf.git_files()
          else
            fzf.files()
          end
        end,
        desc = "Find files",
      },
      { "\\", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
      { "<leader>b", function() require("fzf-lua").buffers() end, desc = "Buffers" },
    },
    opts = {},
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

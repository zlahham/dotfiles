-- UI: colorscheme, statusline, treesitter, icons
return {
  -- Colorscheme (load first, high priority)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "night" },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- Statusline (replaces vim-airline)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        icons_enabled = true,
      },
    },
  },

  -- Treesitter: highlighting (replaces vim-javascript syntax etc.)
  --
  -- NOTE: pinned to the `main` branch. Neovim 0.12's core treesitter is
  -- incompatible with nvim-treesitter's legacy `master` branch (it throws
  -- "attempt to call method 'range'" on injection parsing). `main` is the
  -- rewrite built for 0.11+/0.12. It drops the old module system, so:
  --   * parsers are installed imperatively (require("nvim-treesitter").install)
  --   * highlighting is started per-buffer via a FileType autocmd
  --   * endwise is no longer a TS module -> handled by vim-endwise below
  -- Requires the `tree-sitter` CLI + a C compiler to build parsers.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        -- no `haml` parser exists in the registry -> vim-haml handles haml
        "lua", "ruby", "javascript", "terraform", "hcl",
        "vim", "vimdoc", "bash", "json", "yaml", "markdown", "markdown_inline",
      })
      -- Start highlighting for every buffer that has a parser. pcall no-ops
      -- cleanly on filetypes without one (and handles parser/ft name mismatch).
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args) pcall(vim.treesitter.start, args.buf) end,
      })
    end,
  },

  -- Auto `end` in ruby/lua/vimscript (was a TS module on master; the `main`
  -- branch dropped modules, so use tpope's regex-based version instead).
  { "tpope/vim-endwise", ft = { "ruby", "eruby", "lua", "vim", "sh" } },

  -- Haml syntax (no treesitter parser exists for haml; keep this tiny plugin)
  { "tpope/vim-haml", ft = "haml" },
}

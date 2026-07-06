-- Ruby / Rails: rails helper + test runner
return {
  -- Rails (kept — still the best; lazy-loaded on ruby-ish files)
  {
    "tpope/vim-rails",
    dependencies = { "tpope/vim-projectionist" }, -- powers :A / :R alternate-file jumps
    ft = { "ruby", "eruby", "haml" },
  },

  -- Test runner (replaces thoughtbot/vim-rspec). Keymaps mirror the old
  -- muscle memory: ,t file  ,s nearest  ,l last  ,a all  ,T summary.
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec",
    },
    ft = "ruby",
    config = function()
      require("neotest").setup({
        adapters = { require("neotest-rspec") },
      })
    end,
    keys = {
      { "<leader>t", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: file", ft = "ruby" },
      { "<leader>s", function() require("neotest").run.run() end, desc = "Test: nearest", ft = "ruby" },
      { "<leader>l", function() require("neotest").run.run_last() end, desc = "Test: last", ft = "ruby" },
      { "<leader>a", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test: suite", ft = "ruby" },
      { "<leader>T", function() require("neotest").summary.toggle() end, desc = "Test: summary", ft = "ruby" },
    },
  },
}

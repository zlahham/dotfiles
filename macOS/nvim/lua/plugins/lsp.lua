-- LSP + completion + format + lint (replaces neomake and the old deoplete)
return {
  -- Completion engine (replaces deoplete). Tagged release => prebuilt binary.
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = "default", -- C-y accept, C-n/C-p select, C-space menu (all still work)
        -- Unified accept: one <Tab> accepts whatever suggestion is showing.
        ["<Tab>"] = {
          function(cmp) -- 1. blink menu open -> accept the selected item
            if cmp.is_visible() then return cmp.select_and_accept() end
          end,
          function() -- 2. Copilot ghost text showing -> accept it
            local ok, sug = pcall(require, "copilot.suggestion")
            if ok and sug.is_visible() then sug.accept(); return true end
          end,
          function(cmp) -- 3. inside a snippet -> jump to next placeholder
            if cmp.snippet_active() then return cmp.snippet_forward() end
          end,
          "fallback", -- 4. otherwise a normal Tab (indent)
        },
        ["<S-Tab>"] = {
          function(cmp)
            if cmp.is_visible() then return cmp.select_prev() end
          end,
          function(cmp)
            if cmp.snippet_active() then return cmp.snippet_backward() end
          end,
          "fallback",
        },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = { documentation = { auto_show = true, auto_show_delay_ms = 200 } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "rust" },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },

  -- Mason: installs LSP servers / tools. mason-lspconfig auto-enables them via
  -- the native vim.lsp.enable() (Neovim 0.11+ API).
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    config = function()
      require("mason").setup()

      -- Broadcast completion capabilities to every server (order matters:
      -- do this BEFORE mason-lspconfig enables the servers below).
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Per-server overrides (merged onto lspconfig's shipped defaults).
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      -- ruby_lsp is intentionally NOT mason-installed: it's meant to run from
      -- the project's bundle (`bundle add ruby-lsp` or `gem install ruby-lsp`
      -- once an asdf ruby is set). Mason installing it via `gem` breaks when no
      -- ruby version is active. Enable it only when the executable is present,
      -- so it attaches automatically once ruby-lsp is on PATH.
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "terraformls", "ts_ls" },
        automatic_enable = true, -- calls vim.lsp.enable() for installed servers
      })

      if vim.fn.executable("ruby-lsp") == 1 then
        vim.lsp.enable("ruby_lsp")
      end

      -- LSP keymaps: bound only once a server attaches to the buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local m = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          m("gd", vim.lsp.buf.definition, "Goto Definition")
          m("gr", vim.lsp.buf.references, "References")
          m("K", vim.lsp.buf.hover, "Hover")
          m("<leader>rn", vim.lsp.buf.rename, "Rename")
          m("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        end,
      })
    end,
  },

  -- Formatting (replaces vim-terraform's fmt-on-save; format-on-save for all)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>f", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        ruby = { "rubocop" },
        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  -- Linting (rubocop for ruby; LSP handles the rest via diagnostics)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        ruby = { "rubocop" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
}

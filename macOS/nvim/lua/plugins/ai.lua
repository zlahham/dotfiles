-- AI: GitHub Copilot inline ghost-text suggestions
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",           -- :Copilot auth / status / enable / disable
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,             -- show grey ghost text as you type
        hide_during_completion = true,   -- yield to the blink.cmp popup, no fighting
        keymap = {
          accept = "<C-l>",              -- direct accept; <Tab> also accepts (unified in blink.cmp)
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      -- On for everything; off in noisy/secret buffers.
      filetypes = {
        ["*"] = true,
        [""] = false,
        gitcommit = false,
        gitrebase = false,
      },
    },
  },
}

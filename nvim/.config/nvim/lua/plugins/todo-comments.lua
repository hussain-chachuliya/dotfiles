return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  optional = true,
  opts = {
    keywords = {
      TODO = { icon = " ", color = "warning" },
      IN_DEV = { icon = " " },
      CODE_REVIEW = { icon = "⏲ ", color = "test" },
      FIX = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      DONE = { icon = " ", color = "info" },
      BLOCKED = { icon = " ", color = "warning" },
      -- NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    },
  },
  keys = {
    {
      "<leader>st",
      function()
        Snacks.picker.todo_comments({ keywords = { "TODO" } })
      end,
      desc = "Todo",
    },
    {
      "<leader>sT",
      function()
        Snacks.picker.todo_comments({ keywords = { "TODO", "IN_DEV", "CODE_REVIEW", "DONE", "BLOCKED", "FIX" } })
      end,
      desc = "All tasks",
    },
  },
}

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        grep = {
          hidden = true, -- Search hidden files (e.g., .env)
          -- ignored = true,  -- Search gitignored files/folders
        },
      },
    },
  },
}

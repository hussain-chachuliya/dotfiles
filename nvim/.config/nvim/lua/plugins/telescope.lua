return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = false, -- Forces Telescope to load on Neovim startup
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- optional but recommended
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy Find in Buffer" },
    },
    opts = {
      defaults = {
        path_display = { "truncate" },
      },
      pickers = {
        find_files = {
          hidden = true,
          no_ignore = false, -- Set to true if you want to search inside gitignored folders
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" } -- Removes gitignore and hidden file restrictions
          end,
        },
      },
    },
  },
}

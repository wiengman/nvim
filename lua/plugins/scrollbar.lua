return {
  "petertriho/nvim-scrollbar",
  dependencies = {
    "lewis6991/gitsigns.nvim",
  },
  event = "VeryLazy",
  config = function()
    require("scrollbar").setup({
      excluded_filetypes = {
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "neo-tree",
      },
      handlers = {
        gitsigns = true,
      },
    })
  end,
}

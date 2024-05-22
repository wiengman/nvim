return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        disabled_filetypes = {
          statusline = { "neo-tree", "neo-tree-popup" },
          winbar = { "neo-tree", "neo-tree-popup" },
        },
      },
    })
  end,
}

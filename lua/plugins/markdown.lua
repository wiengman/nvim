return {
  "MeanderingProgrammer/markdown.nvim",
  event = "BufReadPost",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  config = function()
    require("render-markdown").setup({})
  end,
}

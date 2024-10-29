return {
  "folke/trouble.nvim",
  event = "BufReadPost",
  config = function ()
    require("trouble").setup({})
  end
}

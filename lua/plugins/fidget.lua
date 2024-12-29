return {
  "j-hui/fidget.nvim",
  event = "VimEnter",
  config = function ()
    require("fidget").setup({})
  end
}

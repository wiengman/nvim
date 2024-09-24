return {
  "EdenEast/nightfox.nvim",
  priority = 1000,
  config = function()
    require("nightfox").setup({})
    vim.cmd("colorscheme nordfox")
    vim.api.nvim_set_hl(0, "Comment", { fg = "#ffeca5"})
    vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })
  end,
}

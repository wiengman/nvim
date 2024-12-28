return {
  "EdenEast/nightfox.nvim",
  priority = 100,
  config = function()
    require("nightfox").setup({})
    vim.cmd("colorscheme nordfox")

    -- Comment colors
    vim.api.nvim_set_hl(0, "Comment", { fg = "#AFA16D" })
    vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })
  end,
}

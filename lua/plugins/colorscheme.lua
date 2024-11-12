return {
  "EdenEast/nightfox.nvim",
  priority = 1000,
  config = function()
    require("nightfox").setup({})
    vim.cmd("colorscheme nordfox")

    -- Comment colors
    vim.api.nvim_set_hl(0, "Comment", { fg = "#AFA16D" })
    vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })
    -- Make Transparent
    -- vim.api.nvim_set_hl(0, "Normal", { ctermbg = "none" })
    -- vim.api.nvim_set_hl(0, "NonText", { ctermbg = "none" })
  end,
}

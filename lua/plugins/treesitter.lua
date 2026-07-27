return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  version = "v0.9.3",
  lazy = false,
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {},
      auto_install = true,
    })
  end
}

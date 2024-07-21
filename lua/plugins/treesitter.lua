return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {
        "lua",
        "javascript",
        "vim",
        "c",
        "cpp",
        "rust",
        "markdown",
        "markdown_inline"
      },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}

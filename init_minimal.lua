require("lazy_bootstrap")
require("vim_options")
require("lazy").setup(
  {
    require("plugins.colorscheme"),
    require("plugins.wilder"),
    require("plugins.treesitter"),
    require("plugins.comment"),
  },
  require("lazy_options")
)
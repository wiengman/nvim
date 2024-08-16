require("lazy_bootstrap")
require("vim_options")
require("lazy").setup("plugins",
  {
    change_detection = {
      notify = false,
    },
  })

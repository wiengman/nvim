return {
  "camspiers/snap",
  config = function()
    local snap = require("snap")
    local settings = {
      reverse = true,
    }
    local file = snap.config.file:with(settings)
    local vimgrep = snap.config.vimgrep:with(settings)
    snap.maps({
      { "<C-p>",      file({ producer = "ripgrep.file" }) },
      { "<Leader>fb", file({ producer = "vim.buffer" }) },
      { "<Leader>fg", vimgrep({ producer = "ripgrep.vimgrep", args = { "--ignore-case" }, limit = 10000 }) },
    })
  end,
}

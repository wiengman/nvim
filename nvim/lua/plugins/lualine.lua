return {
   "nvim-lualine/lualine.nvim",
  dependencies =  {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count
    require("lualine.themes.cyberdream")
   -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = "cyberdream",
        disabled_filetypes = {
           statusline = {'neo-tree', 'neo-tree-popup', "Terminal"},
           winbar = {'neo-tree', 'neo-tree-popup', "Terminal"}
        },
      },
      sections = {
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
      },
    })
  end,
}

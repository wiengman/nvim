return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      theme = "doom",
      config = {
        center = {
          {
            icon = '🛠',
            icon_hl = 'group',
            desc = ' Open Neovim configuration files',
            desc_hl = 'group',
            key = 's',
            key_hl = 'group',
            key_format = ' %s', -- `%s` will be substituted with value of `key`
            action = "lua vim.api.nvim_command('Neotree dir=' .. vim.fn.stdpath('config'))",
          },
        },
      }
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}

vim.loader.enable()

--leader
vim.g.mapleader = " "


local options = vim.opt

-- Tab control
options.expandtab = true
options.tabstop = 2
options.shiftwidth = 2
options.softtabstop = 2

-- Cursor and lines
options.number = true
options.relativenumber = true
options.cursorline = true

-- file search
options.ignorecase = true
options.smartcase = true

-- Disable swapfile
options.swapfile = false


-- set updatetime
options.updatetime = 300

vim.wo.wrap = false

-- Yank to default clipboard
options.clipboard:append("unnamedplus")
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })


-- hide cmdline when not in use
--[[ options.cmdheight = 0
vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
  pattern = { "*" },
  command = "set cmdheight=1"
})

vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
  pattern = { "*" },
  command = "set cmdheight=0"
}) ]]

vim.api.nvim_command('command! FilePathCp let @+=expand("%:p")')

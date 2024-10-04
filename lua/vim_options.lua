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

-- Set max items from popupmenu
options.pumheight = 15

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


-- Dump Neovim colors to terminal colors
local function dump_colors()
  print("background" .. " : " .. string.format("#%06x", vim.api.nvim_get_hl_by_name('Normal', true).background))
  print("foreground" .. " : " .. string.format("#%06x", vim.api.nvim_get_hl_by_name('Normal', true).foreground))
  print("cursor" .. " : " .. string.format(vim.api.nvim_get_hl_by_name('Cursor', true).foreground))
  print("color0" .. " : " .. vim.g.terminal_color_0)
  print("color1" .. " : " .. vim.g.terminal_color_1)
  print("color2" .. " : " .. vim.g.terminal_color_2)
  print("color3" .. " : " .. vim.g.terminal_color_3)
  print("color4" .. " : " .. vim.g.terminal_color_4)
  print("color5" .. " : " .. vim.g.terminal_color_5)
  print("color6" .. " : " .. vim.g.terminal_color_6)
  print("color7" .. " : " .. vim.g.terminal_color_7)
  print("color8" .. " : " .. vim.g.terminal_color_8)
  print("color9" .. " : " .. vim.g.terminal_color_9)
  print("color10" .. " : " .. vim.g.terminal_color_10)
  print("color11" .. " : " .. vim.g.terminal_color_11)
  print("color12" .. " : " .. vim.g.terminal_color_12)
  print("color13" .. " : " .. vim.g.terminal_color_13)
  print("color14" .. " : " .. vim.g.terminal_color_14)
  print("color15" .. " : " .. vim.g.terminal_color_15)
end

vim.api.nvim_create_user_command('DumpColors', dump_colors, {})

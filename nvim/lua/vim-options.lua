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

-- Yank to default clipboard
options.clipboard:append("unnamedplus")

-- set updatetime
options.updatetime = 300

--leader
vim.g.mapleader = " "

vim.api.nvim_create_augroup("neotree", {})
vim.api.nvim_create_autocmd("UiEnter", {
  desc = "Open Neotree automatically",
  group = "neotree",
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd("Neotree toggle")
    end
  end,
})

return {
	"akinsho/toggleterm.nvim",
  event = "VeryLazy",
	config = function()
		require("toggleterm").setup({
      -- open_mapping = [[<A-t>]],
		})
    vim.keymap.set('t', '<ESC>', [[<C-\><C-n>]], {})
    vim.keymap.set('n', '<A-t>', ':ToggleTerm name=terminal<CR>', {noremap = true, silent = true})
    vim.keymap.set('t', '<A-t>', '<C-\\><C-n>:ToggleTerm<CR>', {noremap = true, silent = true})
	end,
}


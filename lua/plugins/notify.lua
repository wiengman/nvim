return {
	"rcarriga/nvim-notify",
  priority = 51,
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("notify").setup({
			render = "compact",
			stages = "static",
			timeout = 3000,
		})
		vim.notify = require("notify")

    local keymap_opts = {
      noremap = true,
    }
    vim.keymap.set( "n", "<leader>i", require('telescope').extensions.notify.notify, keymap_opts)
	end,
}

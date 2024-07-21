return {
	"numToStr/FTerm.nvim",
	config = function()
		require("FTerm").setup({
			border = "double",
			auto_close = false,
			dimensions = {
				height = 0.9,
				width = 0.9,
			},
		})

		vim.keymap.set("n", "<A-t>", require("FTerm").toggle, {})
		vim.keymap.set("t", "<A-t>", require("FTerm").toggle, {})

		vim.api.nvim_create_user_command("FTermOpen", require("FTerm").open, { bang = true })
		vim.api.nvim_create_user_command("FTermClose", require("FTerm").close, { bang = true })
		vim.api.nvim_create_user_command("FTermExit", require("FTerm").exit, { bang = true })
		vim.api.nvim_create_user_command("FTermToggle", require("FTerm").toggle, { bang = true })
	end,
}


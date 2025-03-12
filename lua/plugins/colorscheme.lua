return {
	"rebelot/kanagawa.nvim",
	priority = 100,
	config = function()
		require("kanagawa").setup({})

		vim.cmd("colorscheme kanagawa-wave")

		vim.api.nvim_set_hl(0, "LineNr", { link = "@variable.parameter" })
		vim.api.nvim_set_hl(0, "SignColumn", { fg = "#938aa9", bg = "bg" })

		local hl = vim.api.nvim_set_hl

		-- Gitsigns
		hl(0, "GitSignsAdd", { fg = "#76946a", bg = "bg" })
		hl(0, "GitSignsChange", { fg = "#dca561", bg = "bg" })
		hl(0, "GitSignsDelete", { fg = "#c34043", bg = "bg" })
	end,
}

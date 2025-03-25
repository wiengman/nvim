return {
	"rebelot/kanagawa.nvim",
	priority = 100,
	config = function()
		require("kanagawa").setup({})

		vim.cmd("colorscheme kanagawa-wave")

		local hl = vim.api.nvim_set_hl

		local column_bg = "#2a2a37"
		-- Column
		hl(0, "LineNr", { fg = "#b8b4d0", bg = column_bg })
		hl(0, "SignColumn", { fg = "#938aa9", bg = column_bg })

		-- Diagnostics
		hl(0, "DiagnosticError", { fg = "#e82424", bg = "#3c2935" })
		hl(0, "DiagnosticWarn", { fg = "#ff9e3b", bg = "#3f3537" })
		hl(0, "DiagnosticInfo", { fg = "#658594", bg = "#2f3340" })
		hl(0, "DiagnosticHint", { fg = "#6a9589", bg = "#30343f" })
		hl(0, "DiagnosticOk", { fg = "#98bb6c", bg = "#35383c" })
	end,
}

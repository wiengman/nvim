return {
	"EdenEast/nightfox.nvim",
	priority = 1000,
	config = function()
    require("nightfox").setup({})
		-- vim.cmd("colorscheme nightfox")
		-- vim.cmd("colorscheme duskfox")
		-- vim.cmd("colorscheme nordfox")
		-- vim.cmd("colorscheme terafox")
		vim.cmd("colorscheme carbonfox")
	end,
}

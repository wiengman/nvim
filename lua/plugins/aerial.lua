return {
"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
  event = "VeryLazy",
	config = function()
		require("aerial").setup({
			close_automatic_events = {
				"unsupported",
			},
			on_attach = function(bufnr)
				vim.keymap.set("n", "<leader>an", "<cmd>AerialNext<CR>", { desc = "Aerial Prev", buffer = bufnr })
				vim.keymap.set("n", "<leader>ap", "<cmd>AerialPrev<CR>", { desc = "Aerial Next", buffer = bufnr })
			end,
		})

		vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial" })
	end,
}

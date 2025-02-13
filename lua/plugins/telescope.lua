return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	event = "VimEnter",
	config = function()
		-- Start of telescope
		-- Find files + directory filter
		-- File grep
		-- Find buffers
		-- recently opened files
		local ts = require("telescope")
		ts.setup()
		ts.load_extension("fzf")

		local builtin = require("telescope.builtin")
		vim.keymap.set(
			"n",
			"<leader>ff",
			function() builtin.find_files({ find_command = { "rg", "--files", "--ignore", "--hidden", "--iglob=!.git/*" } }) end ,
			{ desc = "Telescope find files" }
		)
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope help tags" })
	end,
}

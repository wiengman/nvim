local function filename(_, path)
	local tail = vim.fs.basename(path)
	local parent = vim.fs.dirname(path)
	if parent == "." then
		return tail
	end
	return string.format("%s\t\t%s", tail, parent)
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	event = "VimEnter",
	config = function()
		local ts = require("telescope")
		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")
		ts.setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--ignore",
					"--hidden",
					"--smart-case",
					"--column",
				},
				file_ignore_patterns = {
					"^.git/",
				},
				layout_config = {
					width = 0.95,
					height = 0.95,
				},
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
            ["<C-e>"] = actions.preview_scrolling_down,
            ["<C-y>"] = actions.preview_scrolling_up,
						["<C-Space>"] = actions.to_fuzzy_refine,
            ["<C-h>"] = actions.which_key,
						["<A-d>"] = actions.delete_buffer,
					},
				},
			},

			pickers = {
				find_files = {
					path_display = filename,
				},
				oldfiles = {
					path_display = filename,
				},
				buffers = {
					path_display = filename,
				},
				live_grep = {
					path_display = filename,
				},
			},
		})
		ts.load_extension("fzf")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Telescope help tags" })
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
	end,
}

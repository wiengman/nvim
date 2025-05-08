local gitsigns_status = function()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

return {
	"nvim-lualine/lualine.nvim",
	event = "VimEnter",
	config = function()
		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn", "info", "hint" },
			symbols = {
				error = " ",
				warn = " ",
				info = " ",
				hint = "󰐃 ",
			},
			colored = true,
			always_visible = false,
		}

		local diff = {
			"diff",
			source = gitsigns_status,
			symbols = {
				added = " ",
				modified = " ",
				removed = " ",
			},
		}

		local filetype = {
			"filetype",
			icon_only = true,
			padding = { left = 2, right = 0 },
		}

		local lsp_status = {
			"lsp_status",
			icon = "",
			ignore_lsp = {
				"null-ls",
			},
		}
		local filename = {
			"filename",
			padding = { left = 0, right = 1 },
		}

		require("lualine").setup({
			options = {
				globalstatus = true,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {},
				lualine_c = { filetype, filename, diagnostics, lsp_status, "os.date('%X')" },
				lualine_x = { diff, "branch" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}

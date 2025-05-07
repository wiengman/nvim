return {
	"saghen/blink.cmp",
	version = "1.*",
	build = "cargo build --release",
	opts = {
		keymap = {
			preset = "none",
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<C-J>"] = { "select_next", "fallback" },
			["<C-K>"] = { "select_prev", "fallback" },
			["<C-c>"] = { "cancel", "fallback" },
			["<C-space>"] = { "accept", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		sources = {
			min_keyword_length = 0,
			default = { "lsp", "path", "snippets", "buffer" },
		},
		fuzzy = { implementation = "prefer_rust" },
		completion = {
			list = { selection = { preselect = false } },
			menu = {
				auto_show = true,
				draw = {
					treesitter = { "lsp" },
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", gap = 1 },
					},
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
		},
		cmdline = {
			keymap = { preset = "inherit" },
			completion = {
				list = { selection = { preselect = false } },
				menu = { auto_show = true },
			},
		},
	},
	opts_extend = { "sources.default" },
}

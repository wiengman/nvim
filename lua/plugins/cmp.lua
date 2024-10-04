return {

	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
		"p00f/clangd_extensions.nvim",
	},
	event = "VeryLazy",
	config = function()
		-- Set up nvim-cmp.
		local cmp = require("cmp")
		cmp.setup({
			sorting = {
				comparators = {
					cmp.config.compare.exact,
					cmp.config.compare.offset,
					cmp.config.compare.recently_used,
					require("clangd_extensions.cmp_scores"),
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
					-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
				end,
			},

			-- style
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},

			-- keymaps
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp", group_index = 1 },
				{ name = "luasnip", group_index = 1 },
				{ name = "path", group_index = 1 },
				{ name = "buffer", group_index = 2 },
			}),
			require("luasnip.loaders.from_vscode").lazy_load(),
		})
	end,
}

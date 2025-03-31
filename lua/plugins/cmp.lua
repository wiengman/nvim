return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		"rafamadriz/friendly-snippets",
	},
	event = "InsertEnter",
	config = function()
		-- Set up nvim-cmp.
		local cmp = require("cmp")
		cmp.setup({
			sorting = {
				comparators = {
					cmp.config.compare.exact,
					cmp.config.compare.offset,
					cmp.config.compare.recently_used,
					cmp.config.compare.kind,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
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
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
			}),
		})
		-- `/` cmdline setup.
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})
	end,
}

return {
	"gelguy/wilder.nvim",
	config = function()
		local wilder = require("wilder")
		wilder.setup({
			modes = {
				":",
				"?",
				"/",
			},
		})

		-- pipeline configuration
		wilder.set_option("pipeline", {
			wilder.branch(
				wilder.cmdline_pipeline({
					fuzzy = 2,
					set_pcre2_pattern = 1,
				}),
				wilder.vim_search_pipeline({})
			),
		})

		-- render configuration
		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
				highlighter = {
					wilder.pcre2_highlighter(),
					wilder.basic_highlighter(),
				},
				highlights = {
					border = "Normal",
					accent = wilder.make_hl(
						"WilderAccent",
						"Pmenu",
						{ { a = 1 }, { a = 1 }, { foreground = "#ee5396" } }
					),
				},
				border = "rounded",
				pumblend = 15,
			}))
		)
	end,
}

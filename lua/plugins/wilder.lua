return {
	"gelguy/wilder.nvim",
	dependencies = {
		"romgrk/fzy-lua-native",
	},
  event = "CmdLineEnter",
	config = function()
		local wilder = require("wilder")
		wilder.setup({
			modes = {
				":",
				"?",
				"/",
			},
		})
		wilder.set_option("use_python_remote_plugin", 0)

		-- pipeline configuration
		wilder.set_option("pipeline", {
			wilder.branch(
				wilder.cmdline_pipeline({
					fuzzy = 2,
					fuzzy_filter = wilder.lua_fzy_filter(),
				}),
				wilder.vim_search_pipeline()
			),
		})

		-- render configuration
		wilder.set_option(
			"renderer",
			wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
				highlighter = {
					wilder.lua_fzy_highlighter(),
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

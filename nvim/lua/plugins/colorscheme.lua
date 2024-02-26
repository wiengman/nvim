return {
  --"bluz71/vim-nightfly-guicolors",
  --"pineapplegiant/spaceduck",
  "scottmckendry/cyberdream.nvim",
  priority = 1000, -- load first
  lazy = false,
  -- Cyberdream
   config = function()
      require("cyberdream").setup({
            -- Recommended - see "Configuring" below for more config options
            transparent = true,
            italic_comments = false,
            hide_fillchars = false,
            borderless_telescope = false,
        })
	  -- load colorscheme
  	vim.cmd([[colorscheme cyberdream]])
  end,
}

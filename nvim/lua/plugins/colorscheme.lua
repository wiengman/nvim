return {
  --"bluz71/vim-nightfly-guicolors",
  "pineapplegiant/spaceduck",
  priority = 1000, -- load first
  config = function ()
	  -- load colorscheme
  	--vim.cmd([[colorscheme nightfly]])
  	vim.cmd([[colorscheme spaceduck]])
  end
}

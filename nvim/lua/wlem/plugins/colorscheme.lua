return {
  "bluz71/vim-nightfly-guicolors",
  priority = 1000, -- load first
  config = function ()
	  -- load colorscheme
  	vim.cmd([[colorscheme nightfly]])
  end
}

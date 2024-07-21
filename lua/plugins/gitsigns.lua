return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup({
      current_line_blame_opts = {
        delay = 500,
      },
      current_line_blame = true,
    })
  end
}
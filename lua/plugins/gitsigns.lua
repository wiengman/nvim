local function toggle_inline_diff(gitsigns)
  gitsigns.toggle_linehl()
  gitsigns.toggle_word_diff()
  gitsigns.toggle_deleted()
  gitsigns.toggle_numhl()
end

return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  config = function()
    local gitsigns = require('gitsigns')
    gitsigns.setup({
      current_line_blame_opts = {
        delay = 100,
      },
      current_line_blame = true,
      max_file_length = 40000, -- Default value, just keep here in case

    })

    -- Keymaps
    vim.keymap.set('n', '<leader>gD', gitsigns.diffthis)
    vim.keymap.set('n', '<leader>gd', function() toggle_inline_diff(gitsigns) end)
    vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk)
    vim.keymap.set('n', '<leader>gb', function() gitsigns.blame_line { full = true } end)
    vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk)
    vim.keymap.set('n', '<leader>gS', gitsigns.stage_buffer)
    vim.keymap.set('n', '<leader>gr', gitsigns.reset_hunk)
    vim.keymap.set('n', '<leader>gR', gitsigns.reset_hunk)
    vim.keymap.set('n', '<leader>gu', gitsigns.reset_hunk)

    -- vim.keymap.set('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
    -- vim.keymap.set('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
    -- vim.keymap.set('n', '<leader>hD', function() gitsigns.diffthis('~') end)
  end
}

return {
  "lewis6991/gitsigns.nvim",
  dependencies = { "akinsho/git-conflict.nvim" },
  event = "BufReadPost",
  config = function()
    local gc = require("git-conflict")
    gc.setup({})
    vim.keymap.set('n', '<leader>co', '<Plug>(git-conflict-ours)')
    vim.keymap.set('n', '<leader>ct', '<Plug>(git-conflict-theirs)')
    vim.keymap.set('n', '<leader>cb', '<Plug>(git-conflict-both)')
    vim.keymap.set('n', '<leader>c0', '<Plug>(git-conflict-none)')
    vim.keymap.set('n', '<C-n>c', '<Plug>(git-conflict-prev-conflict)')
    vim.keymap.set('n', '<C-p>c', '<Plug>(git-conflict-next-conflict)')
    local gitsigns = require('gitsigns')
    gitsigns.setup({
      signs = {
        add          = { text = '+' },
        change       = { text = '+' },
        delete       = { text = '-' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged = {
        add          = { text = '+' },
        change       = { text = '+' },
        delete       = { text = '-' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      current_line_blame_opts = {
        delay = 100,
      },
      on_attach = function(bufnr)
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Keymaps
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hu', gitsigns.undo_stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hU', gitsigns.reset_buffer)
        map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)

        map('n', '<leader>hd', gitsigns.diffthis)
        map('n', '<leader>hD', function() gitsigns.diffthis("~") end)

        map('n', '<leader>td', gitsigns.toggle_deleted)
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)

        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
    })
    vim.keymap.set("n", "gs", vim.cmd.Git)
  end

}

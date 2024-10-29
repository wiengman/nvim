return {
  "numToStr/Comment.nvim",
  event = "BufReadPost",
  config = function()
    require("Comment").setup({
      toggler = {
        --Line-Comment toggle keymap
        line = nil,
        block = nil,
      },
      extra = {
        above = nil,
        below = nil,
        eol = nil,
      },
      opleader = {
        --
        line = nil,
        block = nil,
      },
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
    })

    vim.keymap.set("n", "<leader>cc", "<Plug>(comment_toggle_linewise_current)", { desc = "[cc]omment" })
    vim.keymap.set("x", "<leader>cc", "<Plug>(comment_toggle_linewise_visual))", { desc = "[cc]omment (Visual)" })
    vim.keymap.set("n", "<leader>cb", "<Plug>(comment_toggle_blockwise_current)", { desc = "[c]omment [b]lockwise" })
    vim.keymap.set("x", "<leader>cb", "<Plug>(comment_toggle_blockwise_visual))",
      { desc = "[c]omment [b]lockwise (Visual)" })

    local comment_api = require('Comment.api')
    vim.keymap.set("n", "<leader>ca", comment_api.insert.linewise.above, { desc = "[c]omment [a]bove" })
    vim.keymap.set("n", "<leader>cd", comment_api.insert.linewise.below, { desc = "[c]omment [d]own" })
    vim.keymap.set("n", "<leader>ce", comment_api.locked('insert.linewise.eol'), { desc = "[c]omment [e]nd of line" })
  end
}

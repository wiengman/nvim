return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({
      toggler = {
        --Line-Comment toggle keymap
        line = "<leader>cc",
        block = "<leader>cb",
      },
      extra = {
        above = "<leader>ca",
        below = "<leader>cd",
        eol = "<leader>ce",
      },
      opleader = {

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
  end
}

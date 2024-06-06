return {
  {
    'nvim-telescope/telescope.nvim',
    priority = 52,
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")
      --keymaps
      vim.keymap.set({ "n", "i" }, "<C-p>", builtin.find_files, {})
      vim.keymap.set({ "n" }, "<leader>fg", builtin.live_grep, {})
      vim.keymap.set({ "n" }, "<leader>fh", builtin.help_tags, {})
      vim.keymap.set({ "n" }, "<leader>b", builtin.buffers, {})
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({})
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  }
}

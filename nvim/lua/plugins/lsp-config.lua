return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "clangd"
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      --  keymaps
      vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

      -- lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      -- rust-analyzer
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            diagnostics = {
              enabled = true,
            },
            checkOnSave = {
              command = "clippy",
            },
          },
        },
      })

      lspconfig.clangd.setup({
        capabilities = capabilities,
      })
    end,
  },
}

return {
  {
    "williamboman/mason.nvim",
  opts = {
      ui = {
      icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
      }
    }
  },  


  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { 
        "lua_ls",
        "rust_analyzer",
        "clangd",
      }
    }
  },
    "neovim/nvim-lspconfig",
}

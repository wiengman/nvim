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


  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--all-scopes-completion",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--header-insertion-decorators",
            "--pch-storage=memory",
            "--log=info",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--enable-config",
            "--pretty",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
        },
        rust_analyzer = {},
        lua_ls = {},
      },
    },
    setup = {
      clangd = function(_, opts)
        local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
        require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
        return false
      end,
      rust_analyzer = function(_, opts)
        return {
          settings = {
            ["rust-analyzer"] = {
              imports = {
                granularity = {
                  group = "module",
                },
                prefix = "self",
              },
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              cargo = {
                buildScripts = {
                  enable = true,
                },
              },
              procMacro = {
                enable = true,
              },
            },
          },
        }
      end,
      lua_ls = function(_, opts) end,
    },
  },
}

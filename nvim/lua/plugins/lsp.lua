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
    "simrat39/rust-tools.nvim",
    opts = {
      tools = {
        runnables = {
          use_telescope = true,
        },

      inlay_hints = {
        auto = true,
      },
    },

    server = {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = {
              "fmt",
              "clippy"
              },
            },
          },
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
        severity_sort = true,
        underline = true,
        update_in_insert = true, -- Update in runtime
        inlay_hints = {
          enabled = true,
      },

      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },

      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] =  " ",
          [vim.diagnostic.severity.HINT] =  " ",
          [vim.diagnostic.severity.INFO] =  " ",
        },
      },
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local on_attach = function(_client, _buffer)
      end

      local clangd_attach = function(_client, _buffer)
        on_attach(_client, _buffer)
        require("clangd_extensions.inlay_hints").setup_autocmd()
        require("clangd_extensions.inlay_hints").set_inlay_hints()
      end
      lspconfig["clangd"].setup({
        on_attach = clangd_attach,
        capabilities = capabilities,
        settings = {
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
        }
      })



     lspconfig["lua_ls"].setup({
       on_attach = on_attach,
       capabilities = capabilities,
      settings = { -- custom settings for lua
        Lua = {
          -- make the language server recognize "vim" global
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            -- make language server aware of runtime files
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })
    end,
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "p00f/clangd_extensions.nvim",
    },
    event = "VeryLazy",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",        -- lua
          "rust_analyzer", -- rust
          "clangd",        -- c/c++
          "taplo",         -- toml
        },
        automatic_installation = true,
      })
      local keymap_opts = {
        noremap = true,
      }
      --  keymaps
      vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.hover, keymap_opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymap_opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, keymap_opts)
      vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, keymap_opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, keymap_opts)

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      require("mason-lspconfig").setup_handlers({
        function(server)
          lspconfig[server].setup({
            capabilities = capabilities,
          })
        end,
        ["rust_analyzer"] = function()
          -- rust-analyzer will be setup by rustaceanvim
          lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            on_attach = function(_, bufnr)
              if vim.fn.has("nvim-0.10") == 1 then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
              end
            end,
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
        end,
        ["clangd"] = function()
          lspconfig.clangd.setup({
            cmd = {
              "clangd",
              "-j=2",
              "--all-scopes-completion",
              "--background-index",
              "--clang-tidy",
              "--function-arg-placeholders",
              "--enable-config",
              "--pch-storage=memory", -- might cause oom
              "--header-insertion=never",
              "--pretty",
              -- "--malloc-trim", -- Not supported on windows?
            },
            root_dir = lspconfig.util.root_pattern(
              ".git",
              "compile_commands.json",
              ".clangd",
              ".clang-tidy",
              ".clang-format",
              "compile_flags.txt",
              "configure.ac"
            ),
            capabilities = capabilities,
            on_attach = function(_, _)
              vim.keymap.set(
                "n",
                "<A-o>",
                require("clangd_extensions.switch_source_header").switch_source_header,
                keymap_opts
              )

              vim.keymap.set(
                "n",
                "gs",
                require("clangd_extensions.symbol_info").show_symbol_info,
                keymap_opts
              )

              vim.keymap.set(
                "n",
                "gh",
                require("clangd_extensions.type_hierarchy").show_hierarchy,
                keymap_opts
              )

              require("clangd_extensions.inlay_hints").setup_autocmd()
              require("clangd_extensions.inlay_hints").set_inlay_hints()
            end,
          })
        end,
      })
    end,
  },
}

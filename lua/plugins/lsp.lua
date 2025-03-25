local setup_lsp = function(lsp, opts)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	opts.capabilities = capabilities or {}
	require("lspconfig")[lsp].setup(opts)
end

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
				automatic_installation = true,
			})

			local map = function(mode, keys, func, opts)
				opts = opts or {}
				opts.noremap = true
				vim.keymap.set(mode, keys, func, opts)
			end

			--  keymaps
			map({ "n", "i" }, "<C-h>", vim.lsp.buf.hover)
			map("n", "ca", vim.lsp.buf.code_action)

			map("n", "gi", vim.lsp.buf.implementation)
			map("n", "gd", vim.lsp.buf.definition)
			map("n", "gD", vim.lsp.buf.declaration)
			map("n", "gt", vim.lsp.buf.type_definition)
			map("n", "gr", vim.lsp.buf.references)

			map("n", "<C-n>d", function()
				vim.diagnostic.goto_prev({ wrap = true })
			end)
			map("n", "<C-m>d", function()
				vim.diagnostic.goto_next({ wrap = true })
			end)

			-- Set LSP priority
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					severity_sort = true,
				})
			local lspconfig = require("lspconfig")

			setup_lsp("rust_analyzer", {
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

			-- Java
			setup_lsp("jdtls", {})

			-- Python
			setup_lsp("pylsp", {})

			-- Bash
			setup_lsp("bashls", {})

			-- Lua
			setup_lsp("lua_ls", {
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							version = "LuaJIT",
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})

			-- glsl
			-- c/c++
			setup_lsp("clangd", {
				cmd = {
					"clangd",
					"-j=6",
					"--all-scopes-completion",
					"--background-index",
					"--clang-tidy",
					"--function-arg-placeholders",
					"--enable-config",
					"--recovery-ast",
					"--pch-storage=disk",
					"--header-insertion=never",
					"--pretty",
				},
				init_options = {
					fallbackFlags = { "-std=c++20" },
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
				on_attach = function(_, _)
					map("n", "<A-o>", require("clangd_extensions.switch_source_header").switch_source_header)
					map("n", "gs", require("clangd_extensions.symbol_info").show_symbol_info)
					map("n", "gh", require("clangd_extensions.type_hierarchy").show_hierarchy)

					require("clangd_extensions.inlay_hints").setup_autocmd()
					require("clangd_extensions.inlay_hints").set_inlay_hints()
				end,
			})

			-- cmake/make
			setup_lsp("cmake", {})

			-- json
			setup_lsp("jsonls", {})

			-- markdown
			setup_lsp("marksman", {})

			-- asm?
			setup_lsp("asm_lsp", {})

			-- css/scss
			setup_lsp("cssls", {})

			-- hyprls
			setup_lsp("hyprls", {})

			-- glslls
			setup_lsp("glsl_analyzer", {})

			-- toml
			setup_lsp("taplo", {})
		end,

		vim.lsp.set_log_level("off"),
	},
}

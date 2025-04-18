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
			map({ "n" }, "<C-h>", vim.lsp.buf.hover)
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

			vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
			-- Set LSP priority
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					severity_sort = true,
				})
			local lspconfig = require("lspconfig")

			setup_lsp("rust_analyzer", {
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
					"--header-insertion-decorators=false",
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
				on_attach = function(_, bufnr)
					vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

					local function handler(_err, uri)
						if not uri or uri == "" then
							vim.api.nvim_echo({ { "Corresponding file cannot be determined" } }, false, {})
							return
						end
						local file_name = vim.uri_to_fname(uri)
						vim.api.nvim_cmd({
							cmd = "edit",
							args = { file_name },
						}, {})
					end

					map("n", "<A-o>", function()
						vim.lsp.buf_request(0, "textDocument/switchSourceHeader", {
							uri = vim.uri_from_bufnr(0),
						}, handler)
					end, {})
				end,
			})

			-- cmake/make
			setup_lsp("cmake", {})

			-- json
			setup_lsp("jsonls", {})

			-- markdown
			setup_lsp("marksman", {})

			-- toml
			setup_lsp("taplo", {})
		end,

		vim.lsp.set_log_level("off"),
	},
}

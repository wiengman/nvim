local map = function(mode, keys, func, opts)
	opts = opts or {}
	opts.noremap = true
	vim.keymap.set(mode, keys, func, opts)
end

vim.diagnostic.config({
	virtual_text = {
		prefix = function(diagnostic)
			local icons = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "󰋽",
				[vim.diagnostic.severity.HINT] = "󰤱",
			}
			return icons[diagnostic.severity] or ""
		end,
		spacing = 2,
	},
	severity_sort = true,
	signs = false,
})

local group = vim.api.nvim_create_augroup("LspMappings", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end

		-- KEYMAPS
		local opts = { buffer = args.buf, silent = true }
		map("n", "K", vim.lsp.buf.hover, opts)
		map("n", "<c-s-K>", vim.lsp.buf.signature_help, opts)
		map("n", "<leader>", vim.lsp.buf.rename, opts)

		map("n", "ca", vim.lsp.buf.code_action, opts)

		map("n", "gi", vim.lsp.buf.implementation, opts)
		map("n", "gd", vim.lsp.buf.definition, opts)
		map("n", "gD", vim.lsp.buf.declaration, opts)
		map("n", "gt", vim.lsp.buf.type_definition, opts)
		map("n", "gr", vim.lsp.buf.references, opts)
		map("n", "<leader>fm", vim.lsp.buf.format, opts)

		map("n", "<C-p>d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts)
		map("n", "<C-n>d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts)

		vim.api.nvim_create_user_command("LspStart", function(info)
			if vim.lsp.config[info.args] == nil then
				vim.notify(("Invalid server name '%s'"):format(info.args))
				return
			end
			vim.lsp.start(vim.lsp.config[info.args])
		end, { nargs = "?" })

		vim.api.nvim_create_user_command("LspStop", function()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if next(clients) == nil then
				return
			end
			vim.lsp.stop_client(clients[1].id)
		end, {})

		vim.api.nvim_create_user_command("LspRestart", function()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if next(clients) == nil then
				return
			end
			local name = clients[1].name
			vim.lsp.stop_client(clients[1].id)
			local timer = vim.uv.new_timer()
			timer:start(
				100,
				0,
				vim.schedule_wrap(function()
					vim.lsp.start(vim.lsp.config[name])
				end)
			)
		end, {})

		vim.api.nvim_create_user_command("LspEnable", function(info)
			if info.args == nil then
				vim.notify("Usage: :LspEnable <LSP>")
			end
			if vim.lsp.config[info.args] == nil then
				vim.notify("Configuration not found")
				return
			end
			vim.lsp.enable(info.args)
			vim.lsp.start(vim.lsp.config[info.args])
		end, { nargs = "?" })

		vim.api.nvim_create_user_command("LspDisable", function()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if next(clients) == nil then
				return
			end
			local name = clients[1].name
			vim.lsp.stop_client(clients[1].id)
			vim.lsp.enable(name, false)
		end, {})

		return
	end,
})
vim.lsp.enable({ "rust_analyzer", "clangd", "luals" })
vim.lsp.set_log_level("off")

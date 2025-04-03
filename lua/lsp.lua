local map = function(mode, keys, func, opts)
	opts = opts or {}
	opts.noremap = true
	vim.keymap.set(mode, keys, func, opts)
end

vim.diagnostic.config({ virtual_text = true, severity_sort = true })

local group = vim.api.nvim_create_augroup("LspMappings", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		-- if client:supports_method("textDocument/completion") then
		-- 	vim.lsp.completion.enable(true, client.id, args.buf, {
		-- 		autotrigger = true,
		-- 		convert = function(item)
		-- 			return { abbr = item.label:gsub("%b()", "") }
		-- 		end,
		-- 	})
		-- end

		if client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end

		-- Unset 'formatexpr'
		-- vim.bo[args.buf].formatexpr = nil
		-- Unset 'omnifunc'
		-- vim.bo[args.buf].omnifunc = nil

		-- Unmap K
		-- vim.keymap.del("n", "K", { buffer = args.buf })

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

		map("n", "<C-p>d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts)
		map("n", "<C-n>d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts)

	end,
})
vim.lsp.enable({ "rust_analyzer", "clangd", "luals" })
vim.lsp.set_log_level("off")

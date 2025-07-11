local function switch_source_header()
	vim.lsp.buf_request(0, "textDocument/switchSourceHeader", { uri = vim.uri_from_bufnr(0) }, function(_, uri)
		if not uri or uri == "" then
			vim.api.nvim_echo({ { "Corresponding file cannot be determined" } }, false, {})
			return
		end
		local file_name = vim.uri_to_fname(uri)
		vim.api.nvim_cmd({ cmd = "edit", args = { file_name } }, {})
	end)
end

return {
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
		fallbackFlags = { "-std=c++23" },
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = {
		".clangd",
		"compile_commands.json",
	},

	on_attach = function(args)
		vim.api.nvim_buf_create_user_command(0, "ClangdSwitchSourceHeader", function()
			switch_source_header()
		end, { desc = "Switch between source/header" })

		vim.keymap.set("n", "<A-o>", switch_source_header, { bufnr = args.bufnr, silent = true })
	end,
}

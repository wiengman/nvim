local function reload_workspace(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })
	for _, client in ipairs(clients) do
		vim.notify("Reloading Cargo Workspace")
		client.request("rust-analyzer/reloadWorkspace", nil, function(err)
			if err then
				error(tostring(err))
			end
			vim.notify("Cargo workspace reloaded")
		end, 0)
	end
end

return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "cargo.toml" },

	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
		},
	},
	capabilities = {
		experimental = {
			serverStatusNotification = true,
		},
	},
	on_attach = function()
		vim.api.nvim_buf_create_user_command(0, "LspCargoReload", function()
			reload_workspace(0)
		end, { desc = "Reload current cargo workspace" })
	end,
}

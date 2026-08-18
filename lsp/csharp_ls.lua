return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ 'csharp-ls'}, dispatchers, {
      -- csharp-ls attempt to locate sln, slnx or csproj files from cwd, so set cwd to root directory.
      -- If cmd_cwd is provided, use it instead.
      cwd = config.cmd_cwd or config.root_dir,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,
  filetypes = { "cs" },
  root_dir = function(bufnr, on_dir)
    --    local root_dir = vim.fs.root(bufnr, function(fname, _)
    --      return fname:match('%.sln[x]?$') ~= nil
    --    end)
    --
    --    if not root_dir then
    --      -- try find projects root
    --      root_dir = vim.fs.root(bufnr, function(fname, _)
    --        return fname:match('%.csproj$') ~= nil
    --      end)
    --    end
    --    if root_dir then
    --      on_dir(root_dir)
    --    end
    on_dir(vim.fn.getcwd())
  end,
  init_options = {
    AutomaticWorkspaceInit = true,
  },
  get_language_id = function(_, ft)
    if ft == 'cs' then
      return 'csharp'
    end
    return ft
  end,
}

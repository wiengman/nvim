vim.loader.enable()
--leader
vim.g.mapleader = " "
-- Tab control
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
-- Cursor and lines
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
-- file search
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- FileOpts
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.autoread = true
-- Set max items from popupmenu
vim.opt.pumheight = 15
-- set updatetime
vim.opt.updatetime = 300
vim.wo.wrap = false

vim.opt.laststatus = 3

-- Yank to default clipboard
vim.opt.clipboard:append("unnamedplus")

local map = function(mode, keys, func, opts)
  opts = opts or {}
  opts.noremap = true
  vim.keymap.set(mode, keys, func, opts)
end

map({ "n", "v" }, "d", '"_d', { noremap = true })
map("n", "dd", '"_dd', { noremap = true })

--vim.api.nvim_command('command! FilePathCp let @+=expand("%:p")')
--

-- LSP
local group = vim.api.nvim_create_augroup("LspMappings", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
    if client:supports_method("textDocument/completion") then
      local chars = {}
      for i = 32, 126 do
        table.insert(chars, string.char(i))
      end

      client.server_capabilities.completionProvider.triggerCharacters = chars
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

      map("n", "<leader>fm", vim.lsp.buf.format, { silent = true })
      map("i", "<Tab>", function()
        if vim.fn.pumvisible() == 1 and not vim.snippet.active() then
          return "<C-n>"
        end
        return "<Tab>"
      end, { expr = true })

      map("i", "<S-Tab>", function()
        if vim.fn.pumvisible() == 1 and not vim.snippet.active() then
          return "<C-p>"
        end
        return "<S-Tab>"
      end, { expr = true })

      map("i", "<CR>", function()
        if vim.fn.pumvisible() == 1 then
          return "<C-y>"
        end
        return "<CR>"
      end, { expr = true })
    end

    -- KEYMAPS
    local opts = { buffer = args.buf, silent = true }
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<c-s-K>", vim.lsp.buf.signature_help, opts)
    --map("n", "<leader>", vim.lsp.buf.rename, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "gt", vim.lsp.buf.type_definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
  end,
})

vim.lsp.enable({ "clangd", "luals", "csharp_ls" })
vim.lsp.log.set_level("off")

local diagnosticSymbols = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.INFO] = " ",
  [vim.diagnostic.severity.HINT] = "󰐃 ",
  severity = " "
}

-- Diagnostics
vim.diagnostic.config({
  virtual_text = {
    prefix = function(diagnostic)
      return diagnosticSymbols[diagnostic.severity] or diagnosticSymbols["SEVERITY"]
    end,
    spacing = 2,
  },
  severity_sort = true,
  signs = false,
})


map("n", "<C-p>d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { silent = true })
map("n", "<C-n>d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { silent = true })

vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- Statusline
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.cmd("redrawstatus!")
  end,
})


local fileDiff = function()
  vim.b.git_diff = ""
  if vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "") ~= "" then
    local file_name = vim.fn.expand("%")
    if file_name ~= "" then
      local diff = vim.fn.system("git diff --numstat " .. file_name .. " 2>/dev/null")
      local added, removed = diff:match("^(%d+)%s+(%d+)")
      if added ~= nil then
        vim.b.git_diff = vim.b.git_diff .. string.format(" %s ", added)
      end
      if removed ~= nil then
        vim.b.git_diff = vim.b.git_diff .. string.format(" %s ", removed)
      end
    end
  end
end

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    fileDiff()
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    fileDiff()
    local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
    if root ~= "" then
      vim.b.git_branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+$", "")
    else
      vim.b.git_branch = ""
    end
  end,
})

function _G.statusline()
  local modes = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    t = "TERMINAL",
    R = "REPLACE",
    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",
  }
  local mode = modes[vim.fn.mode()]


  local diagnostics = ""
  for diagnostic, count in pairs(vim.diagnostic.count(0)) do
    if count > 0 then
      diagnostics = diagnostics .. diagnosticSymbols[diagnostic] .. count .. " "
    end
  end

  return mode ..
      " " .. vim.b.git_branch .. " " .. vim.b.git_diff .. " " .. "%f" .. " " .. "%y" .. " %l:%c " .. diagnostics
end

vim.o.statusline = "%!v:lua.statusline()"

-- Grep
local grep = function()
  vim.ui.input({ prompt = "grep: " }, function(pattern)
    if pattern then
      vim.cmd("silent grep! " .. vim.fn.fnameescape(pattern))
      vim.cmd("copen")
    end
  end)
end

map("n", "<leader>fg", grep, { silent = true })



-- Find files

function _G.native_find(text, _)
  local files = vim.fn.glob("**/*", true, true)
  local ignore_patterns = {
    "%.git",
    "build",
  }
  local result = {}
  for _, f in ipairs(files) do
    if vim.fn.isdirectory(f) == 0 then
      local skip = false
      for _, pat in ipairs(ignore_patterns) do
        if f:match(pat) then
          skip = true
          break
        end
      end
      if not skip then
        result[#result + 1] = f
      end
    end
  end
  return vim.fn.matchfuzzy(result, text)
end

vim.opt.findfunc = "v:lua.native_find"
map("n", "<leader>ff", ":find ", { silent = false })

-- Diagnostics
map("n", "<leader>d", function()
  -- Add to filter diagnostics present in netrw to avoid library buffer faults from being displayed
  vim.diagnostic.setqflist()
end, { silent = true })

-- Plugins
vim.pack.add({
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/rebelot/kanagawa.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter"
})

-- Explorer
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0

-- Colorscheme
require("kanagawa").setup({})
vim.cmd.colorscheme("kanagawa-wave")
local hl = vim.api.nvim_set_hl
local column_bg = "#2a2a37"
-- Column
hl(0, "LineNr", { fg = "#b8b4d0", bg = column_bg })
hl(0, "SignColumn", { fg = "#938aa9", bg = column_bg })
hl(0, "WinSeparator", { fg = "#dcd7ba" })

-- Diagnostics
hl(0, "DiagnosticError", { fg = "#e82424", bg = "#3c2935" })
hl(0, "DiagnosticWarn", { fg = "#ff9e3b", bg = "#3f3537" })
hl(0, "DiagnosticInfo", { fg = "#658594", bg = "#2f3340" })
hl(0, "DiagnosticHint", { fg = "#6a9589", bg = "#30343f" })
hl(0, "DiagnosticOk", { fg = "#98bb6c", bg = "#35383c" })

-- Oil
require("oil").setup({
  default_file_explorer = true,
  columns = {
    "mtime",
    "size",
    "icon",
    "permissions",
  },
  -- watch for changes outside of the system
  watch_for_changes = true,
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = {
      "actions.select",
      opts = { vertical = true },
      desc = "Open the entry in a vertical split",
    },
    ["<C-h>"] = {
      "actions.select",
      opts = { horizontal = true },
      desc = "Open the entry in a horizontal split",
    },
    ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["<C-k>"] = "actions.preview_scroll_up",
    ["<C-j>"] = "actions.preview_scroll_down",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = {
      "actions.cd",
      opts = { scope = "tab" },
      desc = ":tcd to the current oil directory",
      mode = "n",
    },
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  -- Set to false to disable all of the above keymaps
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
    -- This function defines what is considered a "hidden" file
    is_hidden_file = function(name, bufnr)
      local m = name:match("^%.")
      return m ~= nil
    end,
    -- This function defines what will never be shown, even when `show_hidden` is set
    is_always_hidden = function(name, bufnr)
      return false
    end,
  },
  -- Configuration for the floating window in oil.open_float
  float = {
    -- Padding around the floating window
    padding = 2,
    max_width = 0,
    max_height = 0,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
    get_win_title = nil,
    -- preview_split: Split direction: "auto", "left", "right", "above", "below".
    preview_split = "right",
    -- This is the config that will be passed to nvim_open_win.
    -- Change values here to customize the layout
    override = function(conf)
      return conf
    end,
  },
  -- Configuration for the file preview window
  preview_win = {
    -- Whether the preview window is automatically updated when the cursor is moved
    update_on_cursor_moved = true,
    -- How to open the preview window "load"|"scratch"|"fast_scratch"
    preview_method = "fast_scratch",
    -- A function that returns true to disable preview on a file e.g. to avoid lag
    disable_preview = function(filename)
      return false
    end,
    -- Window-local options to use for preview window buffers
    win_options = {},
  },
})
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Oil" })

require("nvim-treesitter").update():wait()
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local fileType = args.match
    if fileType == "cs" then
      fileType = "c_sharp"
    end

    if vim.tbl_contains(require("nvim-treesitter").get_available(), fileType) then
      require("nvim-treesitter").install(fileType):wait()
      vim.treesitter.start(0, fileType)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end
})

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    "hrsh7th/vim-vsnip", -- snippet engine
    "hrsh7th/cmp-vsnip", -- for autocompletion
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      snippet = { -- configure how nvim-cmp interacts with snippet engine
       expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
       end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
      }),
      -- sources for autocompletion
      sources = cmp.config.sources({
        { name = "path" }, -- file system paths
        { name = "nvim_lsp", keyword_length = 3 },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lua", keyword_length = 2 },
        { name = "vsnip", keyword_length = 2 }, -- snippets
        { name = "buffer", keyword_length = 2}, -- text within current buffer
        { name = "calc" }, -- file system paths
      }),
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
      },
    })

    vim.cmd([[
    set signcolumn=yes
    autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
    ]])

  end,
}

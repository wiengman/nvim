-- Customization stolen from https://github.com/Feferoni/dotfiles/blob/main/nvim/lua/feferoni/plugins/telescope.lua

local function filenameFirst(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then return tail end
  return string.format("%s\t\t%s", tail, parent)
end

local ns_highlight = vim.api.nvim_create_namespace "telescope.highlight"

vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd("TelescopeParent", "\t\t.*$")
            vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
            vim.opt.number = true
        end)
    end,
})

local parse_prompt = function(prompt)
  local first_colon_index = string.find(prompt, ":")
  local numbers_part = prompt:sub(first_colon_index + 1)
  prompt = prompt:sub(1, first_colon_index - 1)

  local line_number, column_number = numbers_part:match("(%d+):?(%d*):?")

  if not line_number then
    line_number = 1
    column_number = 0
  end

  line_number = tonumber(line_number)
  column_number = tonumber(column_number) or 0
  return prompt, line_number, column_number
end

local getLnum = function(lnum, bufnr)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  return math.max(1, math.min(lnum, line_count))
end

local getCnum = function(lnum, cnum, bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)
  if lines and lines[1] then
    return math.max(0, math.min(string.len(lines[1]) - 1, cnum))
  else
    return 0
  end
end

local on_input_filter_cb = function(prompt)
  local find_colon = string.find(prompt, ":")
  if find_colon then
    local file_name, lnum, cnum = parse_prompt(prompt)
    vim.schedule(function()
      local prompt_bufnr = vim.api.nvim_get_current_buf()
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      if not picker or not picker.previewer or not picker.previewer.state then
        return { prompt = prompt }
      end
      local win = picker.previewer.state.winid
      local bufnr = picker.previewer.state.bufnr
      vim.api.nvim_win_set_cursor(win, { getLnum(lnum, bufnr), getCnum(lnum, cnum, bufnr) })
      vim.api.nvim_buf_clear_namespace(bufnr, ns_highlight, 0, -1)
      vim.api.nvim_buf_add_highlight(bufnr, ns_highlight, "TelescopePreviewLine", lnum - 1, 0, -1)
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("normal! zz")
      end)
    end)
    prompt = file_name
  end
  return { prompt = prompt }
end

local attach_mappings = function()
    local actions = require('telescope.actions')
    actions.select_default:enhance {
        post = function()
            local prompt = require("telescope.actions.state").get_current_line()
            local find_colon = string.find(prompt, ":")
            if find_colon then
                local _, lnum, cnum = parse_prompt(prompt)
                vim.api.nvim_win_set_cursor(0, { getLnum(lnum, 0), getCnum(lnum, cnum, 0) })
                vim.cmd("normal! zz")
            end
        end,
    }
    return true
end

return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      --keymaps
      vim.keymap.set({ "n", "i" }, "<C-p>", builtin.find_files, {})
      vim.keymap.set({ "n" }, "<leader>fg", builtin.live_grep, {})
      vim.keymap.set({ "n" }, "<leader>fh", builtin.help_tags, {})
      vim.keymap.set({ "n" }, "<leader>fb", builtin.buffers, {})
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              width = 0.9,
              promt_position = "bottom",
              preview_height = 0.7,
            },
            -- other layout configuration here
          },
        },
        pickers = {
          find_files = {
            path_display = filenameFirst,
            on_input_filter_cb = on_input_filter_cb,
            attach_mappings = attach_mappings,
          },
          oldfiles = {
            path_display = filenameFirst,
            on_input_filter_cb = on_input_filter_cb,
            attach_mappings = attach_mappings,
          },
          git_files = {
            path_display = filenameFirst,
            on_input_filter_cb = on_input_filter_cb,
            attach_mappings = attach_mappings,
          },
          buffers = {
            path_display = filenameFirst,
            on_input_filter_cb = on_input_filter_cb,
            attach_mappings = attach_mappings,
          },
          live_grep = {
            path_display = filenameFirst,
            on_input_filter_cb = on_input_filter_cb,
            attach_mappings = attach_mappings,
          },
          lsp_reference = {
            path_display = filenameFirst,
            on_input_filter_cb = on_input_filter_cb,
            attach_mappings = attach_mappings,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}

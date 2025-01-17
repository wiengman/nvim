local unsaved_buffers = function()
  local unsaved_count = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "modified") then
      unsaved_count = unsaved_count + 1
    end
  end
  if unsaved_count > 0 then
    return string.format("%d Unsaved Buffers", unsaved_count)
  else
    return ""
  end
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VimEnter",
  config = function()
    require("lualine").setup({
      options = {
        globalstatus = true,
      },
      sections = {
        lualine_c = {
          "filename",
          unsaved_buffers,
        },
      },
    })
  end,
}

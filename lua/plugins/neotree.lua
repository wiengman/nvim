local function get_folder(state)
  local node = state.tree:get_node()
  local node_path = node.path
  if not vim.fn.isdirectory(node_path) ~= 0 then
    -- grab folder from file
    node_path = string.gsub(node_path, "([^/]+$)", "")
  end
  return node_path
end


return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    vim.keymap.set({ "n", "i" }, "<C-n>", ":Neotree toggle right<CR>", {})

    require("neo-tree").setup({
      close_if_last_window = true,
      default_component_configs = {
        file_size = {
          enabled = false,
          required_width = 64, -- min width of window required to show this column
        },
        type = {
          enabled = false,
          required_width = 122, -- min width of window required to show this column
        },
        last_modified = {
          enabled = false,
          required_width = 88, -- min width of window required to show this column
        },
        created = {
          enabled = false,
          required_width = 110, -- min width of window required to show this column
        },
      },
      event_handlers = {
        --[[ {
					event = "file_opened",
					handler = function(_)
						require("neo-tree.command").execute({ action = "close" })
					end,
				}, ]]
        --[[ {
					event = "neo_tree_buffer_leave",
					handler = function(_)
						require("neo-tree.command").execute({ action = "close" })
					end,
				}, ]]
      },
      git_status = {
        symbols = {
          -- Change type
          added = "✚",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
          -- Status type
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
      window = {
        auto_expand_width = true,
        position = "right",
      },
      filesystem = {
        group_empty_dirs = true,
        window = {
          mappings = {
            ["<leader>fg"] = function(state)
              local directory_path = get_folder(state)
              require("telescope.builtin").live_grep({
                prompt_title = "live grep in " .. directory_path,
                search_dirs = {
                  directory_path
                }
              })
            end,
            ["<C-p>"] = function(state)
              local directory_path = get_folder(state)
              require("telescope.builtin").find_files({
                prompt_title = "Find files in " .. directory_path,
                search_dirs = {
                  directory_path
                }
              })
            end,
          },
        },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false, -- only works on Windows for hidden files/directories
          hide_by_name = {
            --"node_modules"
          },
          hide_by_pattern = { -- uses glob style patterns
            --"*.meta",
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            --".gitignored",
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            --".DS_Store",
            --"thumbs.db"
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
        follow_current_file = {
          enabled = true,
        },
      },
    })
  end,
}

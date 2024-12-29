return {
  "stevearc/oil.nvim",
  event = "VimEnter",
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      -- Id is automatically added at the beginning, and name at the end
      -- See :help oil-columns
      columns = {
        "icon",
        -- "type"
      },
      -- watch for changes outside of the system
      watch_for_changes = true,
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      -- See :help oil-actions for a list of all available actions
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

    vim.keymap.set("n", "<leader>e", "<cmd>Oil --float<CR>", { desc = "Oil" })

    vim.api.nvim_create_autocmd("User", {
      pattern = "OilEnter",
      callback = vim.schedule_wrap(function(args)
        local oil = require("oil")
        if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
          oil.open_preview()
        end
      end),
    })
  end,
}

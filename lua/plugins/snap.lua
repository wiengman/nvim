return {
  "camspiers/snap",
  event = "VimEnter",
  config = function()
    local snap = require("snap")
    local fzf = snap.get("consumer.fzf")
    local limit = snap.get("consumer.limit")
    local ripgrep_file = snap.get("producer.ripgrep.file")
    local ripgrep_vimgrep = snap.get("producer.ripgrep.vimgrep")
    local buffer = snap.get("producer.vim.buffer")
    local producer_oldfile = snap.get("producer.vim.oldfile")
    local select_file = snap.get("select.file")
    local select_vimgrep = snap.get("select.vimgrep")
    local preview_file = snap.get("preview.file")
    local preview_vimgrep = snap.get("preview.vimgrep")

    -- Find files
    snap.map("<C-p>", function()
      snap.run({
        prompt = "Find Files>",
        producer = fzf(ripgrep_file.args({
          "--hidden",
          "--iglob=!.git/*",
        })),
        select = select_file.select,
        multiselect = select_file.multiselect,
        views = { preview_file },
        reverse = true,
      })
    end)

    -- File grep
    snap.map("<Leader>fg", function()
      snap.run({
        prompt = "File Grep>",
        producer = limit(10000, ripgrep_vimgrep.args({"--ignore-case"})),
        select = select_vimgrep.select,
        multiselect = select_vimgrep.multiselect,
        views = { preview_vimgrep },
        reverse = true,
      })
    end)

    -- Find buffers
    snap.map("<Leader>fb", function()
      snap.run({
        prompt = "Buffers>",
        producer = fzf(buffer),
        select = select_file.select,
        multiselect = select_file.multiselect,
        views = { preview_file },
        reverse = true,
      })
    end)

    -- Oldfiles
    snap.map("<Leader>fo", function()
      snap.run({
        prompt = "Oldfiles>",
        producer = fzf(producer_oldfile),
        select = select_file.select,
        multiselect = select_file.multiselect,
        views = { preview_file },
        reverse = true,
      })
    end)
  end,
}

local obsidian = require('obsidian')
local obsidian_dir = vim.env.OBSIDIAN_DIR
local obsidian_notebook = vim.env.OBSIDIAN_NOTEBOOK

if obsidian_dir == nil then
  vim.notify('$OBSIDIAN_DIR not set; skipping Obsidian setup')
  return
end

if obsidian_notebook == nil then
    vim.notify('$OBSIDIAN_NOTEBOOK not set; skipping Obsidian setup')
    return
end

local obsidian_notebook_dir = obsidian_dir .. '/' .. obsidian_notebook

if not file_exists(obsidian_notebook_dir) then
    vim.notify('$OBSIDIAN_NOTEBOOK "' .. obsidian_notebook .. '" does not exist; skipping Obsidian setup')
    return
end

function note_id(title)
  local normalized_title
  if title ~= nil then
    normalized_title = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
  else
    normalized_title = os.date('%Y-%m-%dT%H:%M')
  end
  return normalized_title
end

obsidian.setup({
  dir = obsidian_dir,

  notes_subdir = vim.fs.normalize('$OBSIDIAN_NOTEBOOK/notes'),

  daily_notes = {
    folder = vim.fs.normalize('$OBSIDIAN_NOTEBOOK/notes/daily'),
  },

  note_id_func = note_id,

  completion = {
    nvim_cmp = true,
  },
})

function obsidian_gf()
  if obsidian.util.cursor_on_markdown_link() then
    return '<cmd>ObsidianFollowLink<CR>'
  else
    return 'gf'
  end
end

vim.keymap.set('n', 'gf', obsidian_gf, { noremap = false, expr = true })

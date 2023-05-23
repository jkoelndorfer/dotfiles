local obsidian = require('obsidian')
local obsidian_dir = vim.env.OBSIDIAN_DIR
local obsidian_notebook = vim.env.OBSIDIAN_NOTEBOOK
local Path = require('plenary.path')

if obsidian_dir == nil then
  vim.notify('$OBSIDIAN_DIR not set; skipping Obsidian setup')
  return
end

if obsidian_notebook == nil then
    vim.notify('$OBSIDIAN_NOTEBOOK not set; skipping Obsidian setup')
    return
end

local obsidian_notebook_dir = vim.fn.resolve(vim.fs.normalize(obsidian_dir .. '/' .. obsidian_notebook))

if not file_exists(obsidian_notebook_dir) then
    vim.notify('$OBSIDIAN_NOTEBOOK "' .. obsidian_notebook .. '" does not exist; skipping Obsidian setup')
    return
end

local notes_subdir = vim.fs.normalize('$OBSIDIAN_NOTEBOOK/notes')
local daily_notes_subdir = notes_subdir .. '/' .. 'daily'
local notes_dir = vim.fn.resolve(obsidian_dir .. '/' .. notes_subdir)

function note_normalize(s)
  return s:gsub('[^A-Za-z0-9]', '-'):lower()
end

function note_id(title)
  local normalized_title
  if title ~= nil then
    normalized_title = note_normalize(title)
  else
    normalized_title = os.date('%Y-%m-%dT%H:%M')
  end
  return normalized_title
end

function note_frontmatter(note)
  local note_path_s = tostring(note.path)
  local notes_dir_pfx = notes_dir .. '/'

  -- The note ID should be the notebook name, plus the entire path of the note
  -- relative to Obsidian notes directory. The file extension is also removed.
  local id = obsidian_notebook .. '-' .. string.sub(note_path_s, notes_dir_pfx:len() + 1, note_path_s:len() - 3)
  return {
    id = note_normalize(id),
    aliases = note.aliases,
    tags = note.tags,
  }
end

obsidian.setup({
  dir = vim.fn.resolve(obsidian_dir),

  notes_subdir = notes_subdir,

  daily_notes = {
    folder = daily_notes_subdir,
  },

  note_id_func = note_id,

  note_frontmatter_func = note_frontmatter,

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

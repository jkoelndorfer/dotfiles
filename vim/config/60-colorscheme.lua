-- Taken from https://stackoverflow.com/a/37040415 and translated to lua.
--
-- Identifies what syntax highlighting group is applied to the text
-- under the cursor.
--
-- See also:
-- help group-name
function syn_group()
  local f = vim.fn
  local s = f.synID(f.line('.'), f.col('.'), 1)
  return {
    minor_syntax_group = f.synIDattr(s, 'name'),
    preferred_syntax_group = f.synIDattr(f.synIDtrans(s), 'name'),
  }
end

function show_syn_group()
  print(vim.inspect(syn_group()))
end

vim.cmd([[
  function! SynGroup()
    execute 'lua show_syn_group()'
  endfunction
]])

local colors_rc = vim.env.DOTFILE_DIR .. '/theme/' .. vim.env.DESKTOP_THEME .. '/vim-colors.lua'
dofile(colors_rc)

vim.cmd([[highlight @text.emphasis gui=italic]])
vim.cmd([[highlight @text.strong gui=bold]])

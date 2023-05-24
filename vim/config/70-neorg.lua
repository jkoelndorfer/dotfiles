local neorg = require('neorg')
local path = require('plenary.path')
local scandir = require('plenary.scandir')

local neorg_workspaces = {}
function handle_neorg_workspace(p, typ)
  if typ == "directory" or typ == "link" then
    -- Construct neorg workspaces from the list of directories and links
    -- in $NOTES_DIR. If $NOTES_DIR contains directories called "personal"
    -- and "work", the resulting neorg_workspaces table will be:
    --
    -- {
    --   personal = "$NOTES_DIR/personal",
    --   work     = "$NOTES_DIR/work",
    -- }
    --
    -- NOTE that the paths will be proper, expanded paths; they will not
    -- include the $NOTES_DIR variable.
    p_components = path.new(p):_split()
    neorg_workspaces[p_components[#p_components]] = p
  end
end

scandir.scan_dir(vim.fs.normalize('$NOTES_DIR'), { depth = 1, add_dirs = true, on_insert = handle_neorg_workspace })

neorg.setup({
  load = {
    ['core.defaults'] = {},
    ['core.dirman'] = {
      config = {
        workspaces = neorg_workspaces,
        index = 'index.norg',
      },
    },
  },
})

function configure_neorg_settings()
  vim.api.nvim_win_set_option(0, 'conceallevel', 2)
  vim.api.nvim_buf_set_option(0, 'smartindent', false)
end

vim.api.nvim_create_augroup("neorg-personal", { clear = true })
vim.api.nvim_create_autocmd(
  {"FileType"},
  {
    pattern = 'norg',
    callback = configure_neorg_settings,
    group = 'neorg-personal',
  }
)

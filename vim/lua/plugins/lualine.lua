local lazyvim_config = require("lazyvim.config")
local icons = lazyvim_config.icons

return {
	"nvim-lualine/lualine.nvim",

	opts = {
		options = {
			section_separators = { left = "", right = " " },
			component_separators = { left = "", right = " " },
		},

		sections = {
			-- Lots of this is copied from
			-- https://github.com/LazyVim/LazyVim/blob/f086bcde253c29be9a2b9c90b413a516f5d5a3b2/lua/lazyvim/plugins/ui.lua#L141-L154
			lualine_c = {
				{
					"diagnostics",
					symbols = {
						error = icons.diagnostics.Error,
						warn = icons.diagnostics.Warn,
						info = icons.diagnostics.Info,
						hint = icons.diagnostics.Hint,
					},
				},
				{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
				{ "filename", path = 1 },
			},
		},
	},
}

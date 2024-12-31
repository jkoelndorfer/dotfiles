return {
	"blink.cmp",
	opts = {
		completion = {
			accept = {
				auto_brackets = {
					enabled = false,
				},
			},
			menu = {
				-- Don't automatically show the completion menu.
				auto_show = false,
				draw = {
					treesitter = { "lsp" },
				},
			},
			ghost_text = {
				enabled = false,
			},
		},
		keymap = {
			preset = "enter",
			["<C-n>"] = { "show", "select_next" },
			["<C-p>"] = { "select_prev" },
			["<Esc>"] = { "cancel", "fallback" },
		},
	},
}

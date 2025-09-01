local logo = [[
       ██╗   ██╗██╗███╗   ███╗
       ██║   ██║██║████╗ ████║
       ██║   ██║██║██╔████╔██║
       ╚██╗ ██╔╝██║██║╚██╔╝██║
        ╚████╔╝ ██║██║ ╚═╝ ██║
         ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

return {
	"snacks.nvim",

	opts = {
		dashboard = {
			enabled = false,
			preset = {
				header = logo,
			},
		},
		scroll = {
			filter = function()
				return false
			end,
		},
	},
}

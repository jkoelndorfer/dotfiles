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

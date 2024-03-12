-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- load custom neovim config
local nvim_config_dir = vim.fn.stdpath("config") .. "/config"

for _, file_path in pairs(vim.fn.readdir(nvim_config_dir)) do
	local full_path = nvim_config_dir .. "/" .. file_path

	if string.match(full_path, "%.lua$") then
		dofile(full_path)
	elseif string.match(full_path, "%.vim$") then
		vim.cmd("source " .. full_path)
	end
end

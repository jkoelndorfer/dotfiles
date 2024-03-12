local neovim_session_flag_path = os.getenv("NEOVIM_SESSION_FLAG")

function WriteSessionFlag(value)
	if neovim_session_flag_path == nil then
		return
	end
	local flag = io.open(neovim_session_flag_path, "w")
	if flag == nil then
		error("failed opening neovim session flag", vim.diagnostic.severity.ERROR)
	end
	flag:write(value)
end

function QuitNeovim()
	WriteSessionFlag(0)
	vim.cmd("qa")
end

function RestartNeovim()
	WriteSessionFlag(1)
	vim.cmd("qa")
end

function QuitProjectTab()
	WriteSessionFlag(2)
	vim.cmd("qa")
end

vim.keymap.set("n", "QQQ", "", { callback = QuitProjectTab })

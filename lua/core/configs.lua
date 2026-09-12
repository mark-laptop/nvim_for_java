local wo = vim.wo
local opt = vim.opt

-- Line Numbers
wo.number = true
wo.relativenumber = true

-- Mouse
opt.mouse = "a"
opt.mousefocus = true

-- Clipboard
opt.clipboard = "unnamed"

-- Indent Settings
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4

-- Other
opt.scrolloff = 8
opt.wrap = false
opt.termguicolors = true

-- Windows may inherit PowerShell as 'shell' while retaining cmd.exe flags.
if vim.fn.has("win32") == 1 and (opt.shell:get():lower():find("powershell") or opt.shell:get():lower():find("pwsh")) then
    opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
    opt.shellquote = ""
    opt.shellxquote = ""
end

-- Fillchars
opt.fillchars = {
	vert = "|",
	fold = " ",
	eob = " ",
	msgsep = "‾",
	foldopen = "▾",
	foldsep = "|",
	foldclose = "▸"
}

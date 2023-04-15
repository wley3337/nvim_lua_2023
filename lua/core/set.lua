local function init()
	-- file references should be added to the init.lua in the releative user ( like undo file ref )
	-- vim.opt.guicursor = "" -- cureser is a bloc in insert mode

	vim.opt.backup = false
	vim.opt.colorcolumn = "80"
	vim.opt.expandtab = true
	vim.opt.hlsearch = false
	vim.opt.incsearch = true
	vim.opt.isfname:append("@-@")

	vim.opt.nu = true

	vim.opt.relativenumber = true
	vim.opt.scrolloff = 8
	vim.opt.shiftwidth = 4
	vim.opt.signcolumn = "yes"
	vim.opt.smartindent = true
	vim.opt.softtabstop = 4
	vim.opt.spelllang = "en_us" -- set before spell to help with performance
	vim.opt.spell = true
	vim.opt.swapfile = false
	vim.opt.tabstop = 4

	vim.opt.updatetime = 50
	vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
	vim.opt.undofile = true

	-- vim.opt.wrap = false
	-- vim.opt.termguicolors = true
end

init()

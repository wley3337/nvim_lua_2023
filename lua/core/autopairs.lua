local status_ok, nvim_autopairs = pcall(require, 'nvim-autopairs')
if not status_ok then
	print("nvim-autopairs could not be found or installed")
	return
end
nvim_autopairs.setup()

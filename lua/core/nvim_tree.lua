local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
	print("nvim_tree could not be found or installed")
	return
end
nvim_tree.setup({
	-- only change is the 'side' value, rest are defaults
	view = {
		adaptive_size = false,
		centralize_selection = false,
		cursorline = true,
		width = 30,
		hide_root_folder = false,
		side = "right", -- default 'left'
		preserve_window_proportions = false,
		number = false,
		relativenumber = false,
		signcolumn = "yes",
		mappings = {
			custom_only = false,
			list = {
				-- user mappings go here
			},
		}
	}
})

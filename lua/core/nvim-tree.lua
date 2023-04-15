local status_ok, nvim_tree = pcall(require, 'nvim-tree')
if not status_ok then
	print("nvim_tree could not be found or installed")
	return
end
nvim_tree.setup({
	diagnostics = {
		enable = true,
	},
	renderer = {
		indent_markers = {
			enable = true,
		},
	},
	-- only change is the 'side' value, rest are defaults
	view = {
		adaptive_size = false,
		centralize_selection = true,
		cursorline = true,
		width = 60,
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
	-- interesting key map ideas
	-- local utils = require("daneharnett.utils")
    -- utils.keymap("n", "<leader>e", "<cmd>NvimTreeFindFileToggle<cr>")
    -- utils.keymap("n", "<C-6>", "<cmd>NvimTreeResize " .. default_width .. "<cr>")
    -- utils.keymap("n", "<C-7>", "<cmd>NvimTreeResize 100<cr>")
    -- utils.keymap("n", "<C-8>", "<cmd>NvimTreeResize +5<cr>")
    -- utils.keymap("n", "<C-9>", "<cmd>NvimTreeResize -5<cr>")
			},
		}
	}

})
-- vim.g.nvim_tree_auto_open = 1

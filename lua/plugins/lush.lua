return {
	-- Use 'dir' to specify the absolute path to your custom theme's folder
	dir = "~/.config/nvim/lua/lush_theme/",
	lazy = false,
	priority = 1000, -- Ensures it loads early
	dependencies = {
		"rktjmp/lush.nvim", -- Required dependency for lush themes
		"craftzdog/solarized-osaka.nvim",
	},
	-- Optional config function if you need specific setup
	config = function()
		-- Any specific configuration for your theme can go here
		vim.cmd([[colorscheme ghost_shell]])
	end,
}

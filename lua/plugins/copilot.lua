return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim", branch = "master" },
		{ "github/copilot.vim" },
	},
	build = "make tiktoken",
	opts = {
		-- See Configuration section for options
		{
			model = "gpt-4.1", -- AI model to use
			temperature = 0.1, -- Lower = focused, higher = creative
			window = {
				layout = "vertical", -- 'vertical', 'horizontal', 'float'
				width = 0.5, -- 50% of screen width
			},
			auto_insert_mode = true, -- Enter insert mode when openin
		},
	},
	config = function()
		-- handle conflict between tab completion with copilot.vim
		vim.g.copilot_no_tab_map = true
		vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
	end,
}

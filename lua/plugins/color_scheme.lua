return {
	-- "oxfist/night-owl.nvim",
	-- 'RishabhRD/nvim-rdark' -- Theme
	-- 'navarasu/onedark.nvim' -- Theme inspired by Atom
	-- 'marko-cerovac/material.nvim' -- Theme inspired by Atom
	"haishanh/night-owl.vim", -- Theme inspired by Atom
	-- "tjdevries/colorbuddy.vim",
	config = function()
		-- load the colorscheme here
		-- require('colorbuddy').colorscheme('night-owl')
		-- require("colorbuddy").colorscheme("nightly")
		require("night-owl").setup()
		vim.cmd.colorscheme("night-owl")
	end,
	dependencies = {
		--	{"haishanh/night-owl.vim"},
		{ "RishabhRD/nvim-rdark" },
		{ "navarasu/onedark.nvim" },
		{ "marko-cerovac/material.nvim" },
		{ "Alexis12119/nightly.nvim" },
		{ "Aryansh-S/fastdark.vim" },
	},

	lazy = false,

	name = "Night Owl",
	-- colorschemes need high priority
	priority = 1000,
}

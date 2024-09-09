return {
	"rmagatti/auto-session",
	config = function()
		local auto_session_ok, auto_session = pcall(require, "auto-session")
		if not auto_session_ok then
			print("Auto Session could not be installed")
			return
		end
		auto_session.setup({
			suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			use_git_branch = true, -- true, false, nil
			log_level = "error",
			-- Set mapping for searching a session.
			-- ⚠️ This will only work if Telescope.nvim is installed
			vim.keymap.set("n", "<Leader>ls", require("auto-session.session-lens").search_session, {
				noremap = true,
			}),
		})
	end,

	dependencies = { "nvim-treesitter/nvim-treesitter" },
}

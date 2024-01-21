return {
	"nvimtools/none-ls.nvim",
	config = function()
		local none_ls_ok, none_ls = pcall(require, "null-ls")
		if not none_ls_ok then
			print("None-LS could not be found or installed")
			return
		end

		local formatting = none_ls.builtins.formatting
		local diagnostics = none_ls.builtins.diagnostics
		local completion = none_ls.builtins.completion

		none_ls.setup({
			sources = {
				-- global
				completion.spell,
				--lua
				formatting.stylua,
				-- js, ts, json
				diagnostics.eslint_d,
				formatting.prettierd,
				-- python
				diagnostics.mypy,
				diagnostics.ruff,
				formatting.black,
			},
		})
	end,
	dependencies = { 'nvim-lua/plenary.nvim', "williamboman/mason.nvim" }
}

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint_ok, lint = pcall(require, "lint")
		if not lint_ok then
			print("Lint could not be found or installed")
			return
		end

		local formatters_linters_ok, formatters_linters = pcall(require, "core.formatters_linters")
		if not formatters_linters_ok then
			print("File type formatters could not be found or installed")
			return
		end

		lint.linters_by_ft = formatters_linters.linters

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
				-- apply global linters
				-- for _, v in pairs(formatters_linters.global) do
				--     lint.try_lint(v)
				-- end
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}

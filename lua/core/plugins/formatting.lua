return {
    "stevearc/conform.nvim",
    config = function()
        local conform_ok, conform = pcall(require, "conform")
        if not conform_ok then
            print("Conform could not be found or installed")
            return
        end

        local formatters_linters_ok, formatters_linters = pcall(require, "core.formatters_linters")
        if not formatters_linters_ok then
            print("File type formatters could not be found or installed")
            return
        end

        conform.setup({
            formatters_by_ft = file_type_formatters.formatters,
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
    event = { "BufReadPre", "BufNewFile" },
}

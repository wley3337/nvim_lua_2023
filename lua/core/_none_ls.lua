return {
    "nvimtools/none-ls.nvim",
    config = function()
        local none_ls_ok, none_ls = pcall(require, "null-ls")
        if not none_ls_ok then
            print("None-LS could not be found or installed")
            return
        end
        local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
        if not mason_null_ls_ok then
            print("Mason-Null-LS could not be found or installed")
            return
        end
        local completion = none_ls.builtins.completion
        local diagnostics = none_ls.builtins.diagnostics
        local formatting = none_ls.builtins.formatting

        none_ls.setup({
            -- sources = all_sources,
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

        mason_null_ls.setup({
            ensure_installed = nil,
            automatic_installation = true,
        })
    end,
    dependencies = { "nvim-lua/plenary.nvim", "williamboman/mason.nvim", "jay-babu/mason-null-ls.nvim" },
}

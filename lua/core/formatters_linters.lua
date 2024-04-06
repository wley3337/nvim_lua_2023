-- values in this table will be used to formate and lint and are ensured install
-- in Mason, Conform, Lint
local M = {}
M.formatters = {
    -- note order in table is order of execution
    css = { "prettierd" },
    graphql = { "prettierd" },
    html = { "prettierd" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    json = { "prettierd" },
    liquid = { "prettierd" },
    lua = { "stylua" },
    markdown = { "prettierd" },
    python = { "isort", "black" },
    svelte = { "prettierd" },
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    yaml = { "prettierd" },
}
M.linters = {
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    python = { "mypy, ruff" },
    svelte = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
}
M.global = { "cspell" }
M.ensure_installed = function()
    local install_items = {}

    for _, v in pairs(M.global) do
        install_items[v] = true
    end
    for _, lang_formatters in pairs(M.formatters) do
        for _, formatter in pairs(lang_formatters) do
            install_items[formatter] = true
        end
    end
    for _, lang_linters in pairs(M.linters) do
        for _, linter in pairs(lang_linters) do
            -- linters are a string list of formatters separated by a ,
            for _linter in string.gmatch(linter, "[^,]+") do
                _linter_remove_white_space = string.gsub(_linter, "%s+", "")
                install_items[_linter_remove_white_space] = true
            end
        end
    end

    return install_items
end

return M

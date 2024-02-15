local lsp_helper_functions_status_ok, lsp_helper_functions = pcall(require, "core.lsp_helper_functions")
if not lsp_helper_functions_status_ok then
    print("LSP Helper Functions could not be found in lsp server file")
    return
end
local M = {}
M.server_configs = {
    jsonls = function()
        local schemastore_status_ok, schemastore = pcall(require, "schemastore")
        if not schemastore_status_ok then
            return
        end

        return {
            settings = {
                json = {
                    schemas = schemastore.json.schemas(),
                    validate = {
                        enable = true,
                    },
                },
            },
        }
    end,
    lua_ls = function()
        local runtime_path = vim.split(package.path, ";")
        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")

        return {
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                        path = runtime_path,
                    },
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        }
    end,
    -- quick lint
    quick_lint_js = function()
        return {}
    end,
    -- rust
    rust_analyzer = function()
        return {
            on_attach = lsp_helper_functions.make_on_attach({
                on_after = function(_, bufnr)
                    local utils = require("core.utils")
                    utils.create_format_on_save_autocmd("Rust", bufnr)
                end,
            }),
        }
    end,
    -- ts server
    tsserver = function()
        local lspconfig_util_status_ok, lspconfig_util = pcall(require, "lspconfig.util")
        if not lspconfig_util_status_ok then
            print("Lsp config util did not load")
            return
        end

        return {
            filetypes = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx",
            },
            init_options = {
                maxTsServerMemory = 12288,
                preferences = {
                    importModuleSpecifierPreference = "non-relative", -- relative, -- non-relative
                },
            },
            on_attach = lsp_helper_functions.make_on_attach({
                on_after = function(client)
                    -- Need to disable formatting because we will use eslint or prettier instead
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
            }),
            -- if the project is a typescript project (has a tsconfig.json)
            -- configure for use in monorepos, spawn one process at the root of
            -- the project (the directory with `.git`).
            -- otherwise, fallback to the location where the tsconfig.json lives
            -- otherwise, it's not a typescript project we want to use this lsp
            -- with.
            root_dir = function(filepath)
                local tsconfig_ancestor = lspconfig_util.root_pattern("tsconfig.json")(filepath)
                if not tsconfig_ancestor then
                    return nil
                end

                local git_ancestor = lspconfig_util.find_git_ancestor(filepath)
                if not git_ancestor then
                    return tsconfig_ancestor
                end

                return git_ancestor
            end,
            single_file_support = false,
        }
    end,
    pyright = function()
        return {}
    end,
}
return M

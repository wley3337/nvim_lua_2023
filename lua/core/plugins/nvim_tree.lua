return {
    "nvim-tree/nvim-tree.lua",
    config = function()

        local status_ok, nvim_tree = pcall(require, "nvim-tree")
        if not status_ok then
            print("nvim_tree could not be found or installed")
            return
        end
        nvim_tree.setup({
            diagnostics = {
                enable = true
            },
            filters = {
                dotfiles = false -- default 'true'
            },
            renderer = {
                indent_markers = {
                    enable = true
                }
            },
            -- just overwrites from default behavior
            view = {
                centralize_selection = true, -- default 'false'
                width = 60, -- defaults to 30, can also be string | number ( column or %) | table | function()
                side = "right", -- default 'left'
                signcolumn = "yes" -- can be: yes, auto, no
            },
            update_focused_file = {
                enable = true,
                update_root = false,
                ignore_list = {}
            }
        })
        -- show mappings `g?`
        -- setup custom mappings `:h nvim-tree-mappings-default`
        -- vim.g.nvim_tree_auto_open = 1
    end,
    dependancies = {"nvim-tree/nvim-web-devicons"},
    lazy = false,
    version = "*"

}

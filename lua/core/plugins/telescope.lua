-- telescope
return {
    "nvim-telescope/telescope.nvim",
    config = function()

        local status_ok, telescope = pcall(require, 'telescope')
        if not status_ok then
            print("TELESCOPE could not be found or installed")
            return
        end
        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`
        telescope.setup {
            defaults = {
                file_ignore_patterns = {"^node_modules/"},
                mappings = {
                    i = {
                        ['<C-u>'] = false,
                        ['<C-d>'] = false
                    }
                }
            }
        }
    end,
    dependencies = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}, {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
    }}
}

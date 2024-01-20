return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        -- Use a protected call so we do not error out on first use
        local status_ok, treesitter_config = pcall(require, "nvim-treesitter.configs")
        if not status_ok then
            print("Nvim-Treesitter or treesiter config could not be found or installed")
            return
        end
        treesitter_config.setup {
            autotag = {
                enable = true
            },
            auto_install = true,

            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = {'c', 'cpp', 'css', 'go', -- 'help', -- parser not available
            'html', 'javascript', 'json', 'lua', "markdown", "markdown_inline", 'python', 'rust', 'toml', 'tsx',
                                'typescript', 'vim', 'yaml'},

            highlight = {
                enable = true
            },
            indent = {
                enable = true,
                disable = {'python'}
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-space>',
                    node_incremental = '<c-space>',
                    scope_incremental = '<c-s>',
                    node_decremental = '<c-backspace>'
                }
            },
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = nil
            },

            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner'
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']m'] = '@function.outer',
                        [']]'] = '@class.outer'
                    },
                    goto_next_end = {
                        [']M'] = '@function.outer',
                        [']['] = '@class.outer'
                    },
                    goto_previous_start = {
                        ['[m'] = '@function.outer',
                        ['[['] = '@class.outer'
                    },
                    goto_previous_end = {
                        ['[M'] = '@function.outer',
                        ['[]'] = '@class.outer'
                    }
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['<leader>a'] = '@parameter.inner'
                    },
                    swap_previous = {
                        ['<leader>A'] = '@parameter.inner'
                    }
                }
            }
        }
    end,
    dependencies = {"nvim-treesitter/completion-treesitter", "nvim-treesitter/nvim-treesitter-context"},
    lazy = false
}

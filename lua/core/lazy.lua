local plugins = { -- theme
-- enhanced vim.notify ui
{"rcarriga/nvim-notify"}, -- treesitter
{
    "nvim-treesitter/nvim-treesitter",
    config = function()
        require("core.treesitter")
    end
}, {"nvim-treesitter/completion-treesitter"}, {"nvim-treesitter/nvim-treesitter-context"}, -- {
--     "nvim-treesitter/playground",
-- },
-- nvim-biscuits
-- {
--     "code-biscuits/nvim-biscuits",
--     config = function()
--         require("core.biscuits").init()
--     end,
-- },
-- A collection of language packs for Vim.
{"sheerun/vim-polyglot"}, -- buffer line (top of buffer)
{
    "akinsho/bufferline.nvim",
    config = function()
        require("core.bufferline").init()
    end,
    dependencies = {{"nvim-tree/nvim-web-devicons"}},
    version = "^3"
}, -- status line (bottom of buffer)
{
    "nvim-lualine/lualine.nvim",
    config = function()
        require("core.lualine")
    end,
    dependencies = {{"nvim-tree/nvim-web-devicons"}}
}, -- lsp
{
    "neovim/nvim-lspconfig",
    config = function()
        require("core.lsp").init()
    end,
    dependencies = {{"williamboman/mason.nvim"}, {"williamboman/mason-lspconfig.nvim"}, {"hrsh7th/cmp-nvim-lsp"},
                    {"j-hui/fidget.nvim" -- virtual text in bottom right as loading
    }, {"b0o/schemastore.nvim" -- json schemas
    }}
}, {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {{"jay-babu/mason-null-ls.nvim"}},
    config = function()
        require("core.null-ls").init()
    end
}, {
    "glepnir/lspsaga.nvim",
    config = function()
        require("core.lspsaga").init()
    end,
    dependencies = {{"neovim/nvim-lspconfig"}},
    event = "BufRead"
}, -- completion
{
    "hrsh7th/nvim-cmp",
    config = function()
        require("core.completion").init()
    end,
    dependencies = {{"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-buffer"}, {"onsails/lspkind-nvim"}, {"L3MON4D3/LuaSnip"},
                    {"saadparwaiz1/cmp_luasnip"}}
}, -- file-tree sidebar explorer
{
    "nvim-tree/nvim-tree.lua",
    config = function()
        require("core.nvim-tree")
    end
}, -- harpoon
{
    "ThePrimeagen/harpoon",
    dependencies = {{"nvim-lua/plenary.nvim"}}
}, -- trouble
-- {
--     "folke/trouble.nvim",
--     config = function()
--         require("core.trouble").init()
--     end,
--     dependencies = {
--         {
--             "nvim-tree/nvim-web-devicons",
--         },
--     },
-- },
-- editorconfig
{"editorconfig/editorconfig-vim"}, -- vim-smoothie for smooth scrolling
{"psliwka/vim-smoothie"}, -- comments
{
    "numToStr/Comment.nvim",
    config = function()
        require("core.comment")
    end
}, -- autopairs
{
    "windwp/nvim-autopairs",
    config = function()
        require("core.autopairs")
    end
}, -- terminal
-- {
--     "akinsho/toggleterm.nvim",
--     config = function()
--         require("core.toggleterm").init()
--     end,
-- },
-- run tests
-- { "vim-test/vim-test",
--     config = function()
--         require("core.tests").init()
--     end,
-- },
-- show colors visually
-- {
--     "norcalli/nvim-colorizer.lua",
--     config = function()
--         require("core.colorizer").init()
--     end,
-- },
-- git
{
    "lewis6991/gitsigns.nvim",
    config = function()
        require("core.git_signs")
    end
}, {"tpope/vim-fugitive"}, {"mfussenegger/nvim-dap"}, {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap"},
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup()
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.after.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end
}, {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {"mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui"},
    config = function(_, opts)
        local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
        require("dap-python").setup(path)
    end
}, {
    -- "APZelos/blamer.nvim",
    "f-person/git-blame.nvim", -- use different git blame
    config = function()
        require("core.git_blame")
    end
}, {
    "windwp/nvim-ts-autotag",
    config = function()
        require("core.nvim_ts_autotag")
    end
}}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "--single-branch", "https://github.com/folke/lazy.nvim.git",
                   lazypath})
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("core.plugins")

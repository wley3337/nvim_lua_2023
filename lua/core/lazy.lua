local plugins = { -- theme
-- enhanced vim.notify ui
{"rcarriga/nvim-notify"}, -- treesitter
-- {
--     "nvim-treesitter/playground",
-- },
-- nvim-biscuits
-- {
--     "code-biscuits/nvim-biscuits",
--     config = function()
--         require("core.biscuits").init()
--     end,
-- },
-- lsp
{
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
}, -- file-tree sidebar explorer
-- trouble
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
{"editorconfig/editorconfig-vim"}, -- terminal
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
{"mfussenegger/nvim-dap"}, {
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
}}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "--single-branch", "https://github.com/folke/lazy.nvim.git",
                   lazypath})
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup("core.plugins")

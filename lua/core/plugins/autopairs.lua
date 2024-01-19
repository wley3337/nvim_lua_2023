-- autopairs
return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
    -- old setup function below for reference
    -- config = function()
    --     local status_ok, nvim_autopairs = pcall(require, 'nvim-autopairs')
    --     if not status_ok then
    --         print("nvim-autopairs could not be found or installed")
    --         return
    --     end

    --     nvim_autopairs.setup({
    --         check_ts = true, -- enable treesitter
    --         ts_config = {
    --             lua = {"string"}, -- don't add pairs in lua string treesitter nodes
    --             javascript = {"template_string"} -- don't add pairs i javascript tempalte_string
    --         }
    --     })

    --     -- import nvim-autopairs completion functionality safely
    --     local cmp_autopairs_setup, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
    --     if not cmp_autopairs_setup then
    --         print("cmp_autopairs could not be found or installed")
    --         return
    --     end

    --     -- import nvim-cmp plugin safely (completions plugin)
    --     local cmp_setup, cmp = pcall(require, "cmp")
    --     if not cmp_setup then
    --         print("cmp in autopairs could not be found or installed")
    --         return
    --     end

    --     -- make autopairs and completion work together
    --     cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    -- end
}

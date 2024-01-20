return {
    -- "APZelos/blamer.nvim",
    "f-person/git-blame.nvim", -- use different git blame
    config = function()
        vim.g.gitblame_enabled = false
        -- vim.g.gitblame_message_template = "<summary> • <date> • <author>" -- default get blame template
    end
}

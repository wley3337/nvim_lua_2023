return {
    "glepnir/lspsaga.nvim",
    config = function()
        local status_ok, lspsaga = pcall(require, "lspsaga")
        if not status_ok then
            print("LSP Saga did not load correctly")
            return
        end

        lspsaga.setup({})
    end,
    dependencies = { { "neovim/nvim-lspconfig" } },
    event = "BufRead",
}

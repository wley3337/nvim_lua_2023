-- completion
return {
    "hrsh7th/nvim-cmp",
    config = function()
        local cmp_status_ok, cmp = pcall(require, "cmp")
        if not cmp_status_ok then
            print("CMP did not load.")
            return
        end
        local lspkind_status_ok, lspkind = pcall(require, "lspkind")
        if not lspkind_status_ok then
            print("LSPKind did not load.")
            return
        end
        local status_ok_luasnip, luasnip = pcall(require, "luasnip")
        if not status_ok_luasnip then
            print("luasnip could not be found or installed")
            return
        end
        local status_ok_luasnip_vs_code, luasnip_vs_code = pcall(require, "luasnip.loaders.from_vscode")

        if not status_ok_luasnip_vs_code then
            print("luasnip VS Code snippetescould not be found or installed")
            return
        end
        -- adds snippets from lua snip to cmp
        luasnip_vs_code.lazy_load()

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,preview,noselect",
            },
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                -- snippet window look
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "luasnip" },  -- For luasnip users.
                { name = "nvim_lsp" }, -- lsp completions
                { name = "buffer" },
                { name = "path" },     -- file system paths
            }),
            -- sorting = {
            --     comparators = {
            --         cmp.config.compare.sort_text,
            --         cmp.config.compare.score,
            --         cmp.config.compare.order,
            --         cmp.config.compare.offset,
            --         cmp.config.compare.kind,
            --         cmp.config.compare.length,
            --         cmp.config.compare.exact,
            --     },
            -- },
        })
    end,
    event = { "InsertEnter" },
    dependencies = {
        { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "onsails/lspkind-nvim",
        "rafamadriz/friendly-snippets",
        "saadparwaiz1/cmp_luasnip",
    },
}

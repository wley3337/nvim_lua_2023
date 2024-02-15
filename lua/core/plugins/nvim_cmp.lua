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
				{ name = "nvim_lsp" }, -- lsp completions
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		-- Set configuration for specific filetype.
		-- cmp.setup.filetype("gitcommit", {
		--     sources = cmp.config.sources({
		--         { name = "git" }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
		--     }, {
		--         { name = "buffer" },
		--     }),
		-- })

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		-- cmp.setup.cmdline({ "/", "?" }, {
		--     mapping = cmp.mapping.preset.cmdline(),
		--     sources = {
		--         { name = "buffer" },
		--     },
		-- })

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		-- cmp.setup.cmdline(":", {
		--     mapping = cmp.mapping.preset.cmdline(),
		--     sources = cmp.config.sources({
		--         { name = "path" },
		--     }, {
		--         { name = "cmdline" },
		--     }),
		-- })

		-- OLD
		-- cmp.setup({
		--     experimental = {
		--         ghost_text = true,
		--     },
		--     formatting = {
		--         format = lspkind.cmp_format({
		--             with_text = true,
		--             menu = {
		--                 buffer = "[buf]",
		--                 nvim_lsp = "[LSP]",
		--             },
		--         }),
		--     },
		--     mapping = cmp.mapping.preset.insert({
		--         -- ThePrimeagen section start
		--         -- local cmp_select = { behavior = cmp.SelectBehavior.Select }
		--         -- local cmp_mappings = lsp.defaults.cmp_mappings({
		--         --     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		--         --     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		--         --     ['<C-y>'] = cmp.mapping.confirm({ select = true }),
		--         --     ["<C-Space>"] = cmp.mapping.complete(),
		--         -- })
		--         -- -- disable completion with tab
		--         -- -- this helps with copilot setup
		--         -- cmp_mappings['<Tab>'] = nil
		--         -- cmp_mappings['<S-Tab>'] = nil
		--         -- ThePrimeagen section end
		--         ["<C-d>"] = cmp.mapping.scroll_docs(-4),
		--         ["<C-f>"] = cmp.mapping.scroll_docs(4),
		--         ["<C-Space>"] = cmp.mapping.complete(),
		--         ["<CR>"] = cmp.mapping.confirm({
		--             behavior = cmp.ConfirmBehavior.Replace,
		--             select = true,
		--         }),
		--         ["<Tab>"] = cmp.mapping(function(fallback)
		--             if cmp.visible() then
		--                 cmp.select_next_item()
		--             elseif luasnip.expand_or_jumpable() then
		--                 luasnip.expand_or_jump()
		--             else
		--                 fallback()
		--             end
		--         end, { "i", "s" }),
		--         ["<S-Tab>"] = cmp.mapping(function(fallback)
		--             if cmp.visible() then
		--                 cmp.select_prev_item()
		--             elseif luasnip.jumpable(-1) then
		--                 luasnip.jump(-1)
		--             else
		--                 fallback()
		--             end
		--         end, { "i", "s" }),
		--         -- Dane Harentt section start
		--         -- -- scroll up the docs window
		--         -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
		--         -- -- scroll down the docs window
		--         -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
		--         -- -- open completion popup when in insert mode and its not open
		--         -- ["<C-Space>"] = cmp.mapping.complete(),
		--         -- -- close completion popup with no suggestion
		--         -- ["<C-e>"] = cmp.mapping.abort(),
		--         -- -- complete the currently selected suggestion
		--         -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
		--         -- Dane Harentt section end
		--     }),
		--     snippet = {
		--         expand = function(args)
		--             require("luasnip").lsp_expand(args.body)
		--         end,
		--     },
		--     sorting = {
		--         comparators = {
		--             cmp.config.compare.sort_text,
		--             cmp.config.compare.score,
		--             cmp.config.compare.order,
		--             cmp.config.compare.offset,
		--             cmp.config.compare.kind,
		--             cmp.config.compare.length,
		--             cmp.config.compare.exact,
		--         },
		--     },
		--     sources = cmp.config.sources(
		--         { {
		--             name = "nvim_lsp",
		--         }, {
		--             name = "luasnip",
		--         } },
		--         { {
		--             name = "buffer",
		--             keyword_length = 5,
		--         } }
		--     ),
		--     window = {
		--         completion = cmp.config.window.bordered(),
		--         documentation = cmp.config.window.bordered(),
		--     },
		-- })
	end,
	dependencies = {
		"L3MON4D3/LuaSnip",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-nvim-lsp",
		"onsails/lspkind-nvim",
		"rafamadriz/friendly-snippets",
		"saadparwaiz1/cmp_luasnip",
	},
}

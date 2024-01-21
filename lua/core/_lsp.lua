local M = {}
local server_configs = {
	jsonls = function()
		local schemastore_status_ok, schemastore = pcall(require, "schemastore")
		if not schemastore_status_ok then
			return
		end

		return {
			settings = {
				json = {
					schemas = schemastore.json.schemas(),
					validate = { enable = true },
				},
			},
		}
	end,
	lua_ls = function()
		local runtime_path = vim.split(package.path, ";")
		table.insert(runtime_path, "lua/?.lua")
		table.insert(runtime_path, "lua/?/init.lua")

		return {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = runtime_path,
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = {
						enable = false,
					},
				},
			},
		}
	end,
	-- quick lint
	quick_lint_js = function()
		return {}
	end,
	-- rust
	rust_analyzer = function()
		return {
			on_attach = M.make_on_attach({
				on_after = function(_, bufnr)
					local utils = require("core.utils")
					utils.create_format_on_save_autocmd("Rust", bufnr)
				end,
			}),
		}
	end,
	--ts server
	tsserver = function()
		local lspconfig_util_status_ok, lspconfig_util = pcall(require, "lspconfig.util")
		if not lspconfig_util_status_ok then
			print("Lsp config util did not load")
			return
		end

		return {
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			init_options = {
				maxTsServerMemory = 12288,
				preferences = {
					importModuleSpecifierPreference = "non-relative", -- relative, -- non-relative
				},
			},
			on_attach = M.make_on_attach({
				on_after = function(client)
					-- Need to disable formatting because we will use eslint or prettier instead
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			}),
			-- if the project is a typescript project (has a tsconfig.json)
			-- configure for use in monorepos, spawn one process at the root of
			-- the project (the directory with `.git`).
			-- otherwise, fallback to the location where the tsconfig.json lives
			-- otherwise, it's not a typescript project we want to use this lsp
			-- with.
			root_dir = function(filepath)
				local tsconfig_ancestor = lspconfig_util.root_pattern("tsconfig.json")(filepath)
				if not tsconfig_ancestor then
					return nil
				end

				local git_ancestor = lspconfig_util.find_git_ancestor(filepath)
				if not git_ancestor then
					return tsconfig_ancestor
				end

				return git_ancestor
			end,
			single_file_support = false,
		}
	end,
	pyright = function()
		return {}
	end,
}
function M.init()
	-- core lsp
	local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
	if not lspconfig_status_ok then
		return
	end
	-- mason
	local mason_status_ok, mason = pcall(require, "mason")
	if not mason_status_ok then
		print("mason could not be found or installed")
		return
	end
	--mason lsp config
	local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not mason_lspconfig_status_ok then
		print("mason lsp-config could not be found or installed")
		return
	end
	-- cmp
	local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if not cmp_nvim_lsp_status_ok then
		print("cmp-nvim-lsp could not be found or installed")
		return
	end

	-- build servers to initialize
	local client_capabilities = vim.lsp.protocol.make_client_capabilities()
	local capabilities =
		vim.tbl_deep_extend("force", client_capabilities, cmp_nvim_lsp.default_capabilities(client_capabilities))

	local servers = {}
	for server_name, make_server_config in pairs(server_configs) do
		local server_config = make_server_config()
		if server_config then
			servers[server_name] = vim.tbl_extend("keep", server_config, {
				capabilities = capabilities,
				on_attach = M.make_on_attach(),
			})
		end
	end

	mason.setup()
	mason_lspconfig.setup({
		ensure_installed = vim.tbl_keys(servers),
	})
	mason_lspconfig.setup_handlers({
		function(server_name)
			lspconfig[server_name].setup(servers[server_name])
		end,
	})

	local fidget_status_ok, fidget = pcall(require, "fidget")
	if not fidget_status_ok then
		print("fidget could not be found or installed")
		return
	end
	fidget.setup({})
end

M.setup_diagnostics = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text if you want
		virtual_text = true,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}
	vim.diagnostic.config(config)
end

M.attach_keymaps_to_buffer = function(bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	local builtin = require("telescope.builtin")
	local lsp_saga_keymaps = require("core.lspsaga")
	lsp_saga_keymaps.attach_keymaps_to_buffer(bufnr)

	nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", builtin.lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
	nmap("<leader>hd", vim.diagnostic.open_float, "[H]over [D]iagnostic")

	-- See `:help K` for why this keymap
	--nmap("K", vim.lsp.buf.hover, "Hover Documentation") -- covered in lsp saga key maps
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- Create a command `:Format` local to the LSP buffer
	vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
		vim.lsp.buf.format()
	end, { desc = "Format current buffer with LSP" })
	-- local opts = { buffer = bufnr, remap = false }
	-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	-- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	-- vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
	-- vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
	-- vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
	-- vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
	-- vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
	-- vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
	-- vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
	-- vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

	-- these are the two plugins that Dane Harenet used
	-- local my_lspsaga = require("core.lspsaga")
	-- local my_trouble = require("core.trouble")
	-- my_lspsaga.attach_keymaps_to_buffer(bufnr)
	-- my_trouble.attach_keymaps_to_buffer(bufnr)
end

M.make_on_attach = function(opts)
	opts = opts or {}

	return function(client, bufnr)
		M.setup_diagnostics()
		M.attach_keymaps_to_buffer(bufnr)

		if opts.on_after and type(opts.on_after) == "function" then
			opts.on_after(client, bufnr)
		end
	end
end

-- local status_ok, lsp = pcall(require, 'lsp-zero')
-- if not status_ok then
--     print("LSP-ZERO could not be found or installed")
--     return
-- end
--
-- local status_ok_neodev, neodev = pcall(require, 'neodev')
-- if not status_ok_neodev then
--     print("neodev could not be found or installed")
--     return
-- end
-- -- Setup neovim lua configuration
-- neodev.setup()

-- local status_ok_mason, mason = pcall(require, 'mason')
-- if not status_ok_mason then
--     print("mason could not be found or installed")
--     return
-- end
-- Setup mason so it can manage external tooling
-- mason.setup()

-- local status_ok_fidget, fidget = pcall(require, 'fidget')
-- if not status_ok_fidget then
--     print("fidget could not be found or installed")
--     return
-- end
-- -- Turn on lsp status information
-- fidget.setup()

-- checkout https://github.com/ThePrimeagen/init.lua/blob/master/after/plugin/lsp.lua for a more customized setup
-- nvim-cmp setup
-- local status_ok_cmp, cmp = pcall(require, 'cmp')
-- if not status_ok_cmp then
--     print("cmp could not be found or installed")
--     return
-- end
--
-- local status_ok_luasnip, luasnip = pcall(require, 'luasnip')
-- if not status_ok_luasnip then
--     print("luasnip could not be found or installed")
--     return
-- end

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
-- local on_attach = function(client, bufnr)
--     if client.name == "eslint" then
--         vim.cmd.LspStop('eslint')
--         return
--     end
--     -- NOTE: Remember that lua is a real programming language, and as such it is possible
--     -- to define small helper and utility functions so you don't have to repeat yourself
--     -- many times.
--     --
--     -- In this case, we create a function that lets us more easily define mappings specific
--     -- for LSP related items. It sets the mode, buffer and description for us each time.
--     local nmap = function(keys, func, desc)
--         if desc then
--             desc = 'LSP: ' .. desc
--         end
--
--         vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
--     end
--
--     local builtin = require('telescope.builtin')
--
--     nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--     nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
--
--     nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
--     nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
--     nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
--     nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
--     nmap('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
--     nmap('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
--
--     -- See `:help K` for why this keymap
--     nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
--     nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
--
--     -- Lesser used LSP functionality
--     nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--     nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
--     nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
--     nmap('<leader>wl', function()
--         print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--     end, '[W]orkspace [L]ist Folders')
--
--     -- Create a command `:Format` local to the LSP buffer
--     vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
--         vim.lsp.buf.format()
--     end, { desc = 'Format current buffer with LSP' })
--     -- local opts = { buffer = bufnr, remap = false }
--     -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--     -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--     -- vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
--     -- vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
--     -- vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
--     -- vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
--     -- vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
--     -- vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
--     -- vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
--     -- vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
-- end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
-- local servers = {
--     -- clangd = {},
--     -- gopls = {},
--     -- pyright = {},
--     rust_analyzer = {
--         cmd = {
--             "rustup", "run", "stable", "rust-analyzer"
--         }
--     },
--     -- tsserver = {},
--
--     sumneko_lua = {
--         Lua = {
--             workspace = { checkThirdParty = false },
--             telemetry = { enable = false },
--             -- Fix Undefined global 'vim'
--             diagnostics = {
--                 globals = { 'vim' }
--             }
--         },
--     },
-- }

-- lsp.preset('recommended')
-- lsp.ensure_installed({
--     'tsserver',
--     'eslint',
--     'sumneko_lua',
--     'rust_analyzer',
-- })

--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
--
--
-- -- Ensure the servers above are installed
-- local mason_lspconfig = require 'mason-lspconfig'
--
-- mason_lspconfig.setup {
--     ensure_installed = vim.tbl_keys(servers),
-- }

-- mason_lspconfig.setup_handlers {
--     function(server_name)
--         require('lspconfig')[server_name].setup {
--             capabilities = capabilities,
--             on_attach = on_attach,
--             settings = servers[server_name],
--
--             cmd = (server_name == 'rust_analyzer') and { "rustup", "run", "stable", "rust-analyzer" } or {}
--         }
--     end,
-- }

-- lsp.set_preferences({
--     suggest_lsp_servers = false,
--     sign_icons = {
--         error = 'E',
--         warn = 'W',
--         hint = 'H',
--         info = 'I'
--     }
-- })
-- cmp.setup {
--     snippet = {
--         expand = function(args)
--             luasnip.lsp_expand(args.body)
--         end,
--     },
--     mapping = cmp.mapping.preset.insert {
--
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
--         ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-f>'] = cmp.mapping.scroll_docs(4),
--         ['<C-Space>'] = cmp.mapping.complete(),
--         ['<CR>'] = cmp.mapping.confirm {
--             behavior = cmp.ConfirmBehavior.Replace,
--             select = true,
--         },
--         ['<Tab>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 cmp.select_next_item()
--             elseif luasnip.expand_or_jumpable() then
--                 luasnip.expand_or_jump()
--             else
--                 fallback()
--             end
--         end, { 'i', 's' }),
--         ['<S-Tab>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--                 cmp.select_prev_item()
--             elseif luasnip.jumpable(-1) then
--                 luasnip.jump(-1)
--             else
--                 fallback()
--             end
--         end, { 'i', 's' }),
--     },
--     sources = {
--         { name = 'nvim_lsp' },
--         { name = 'luasnip' },
--     },
-- }
--
-- lsp.setup()
-- vim.diagnostic.config({ virtual_text = true, })
return M

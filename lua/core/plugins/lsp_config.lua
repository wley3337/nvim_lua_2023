-- over all pattern is that this should be able to run for
-- every server config in lsp_servers without any changes.
return {
	{
		"williamboman/mason.nvim",
		config = function()
			-- mason
			local mason_status_ok, mason = pcall(require, "mason")
			if not mason_status_ok then
				print("mason could not be found or installed")
				return
			end
			mason.setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- lsp servers
			local lsp_servers_status_ok, lsp_servers = pcall(require, "core.lsp_servers")
			if not lsp_servers_status_ok then
				print("Lsp Servers could not be found")
				return
			end
			-- lsp helper functions
			local lsp_helper_functions_status_ok, lsp_helper_functions = pcall(require, "core.lsp_helper_functions")
			if not lsp_helper_functions_status_ok then
				print("LSP Helper Functions could not be found")
				return
			end
			-- core lsp
			local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
			if not lspconfig_status_ok then
				print("LSP Config could not be found or installed")
				return
			end
			-- cmp
			local cmp_nvim_lsp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if not cmp_nvim_lsp_status_ok then
				print("cmp-nvim-lsp could not be found or installed")
				return
			end
			-- mason lsp config
			local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
			if not mason_lspconfig_status_ok then
				print("mason lsp-config could not be found or installed")
				return
			end
			-- build servers to initialize
			local client_capabilities = vim.lsp.protocol.make_client_capabilities()
			local capabilities = vim.tbl_deep_extend(
				"force",
				client_capabilities,
				cmp_nvim_lsp.default_capabilities(client_capabilities)
			)

			local servers = {}
			for server_name, make_server_config in pairs(lsp_servers.server_configs) do
				local server_config = make_server_config()
				if server_config then
					servers[server_name] = vim.tbl_extend("keep", server_config, {
						capabilities = capabilities,
						on_attach = lsp_helper_functions.make_on_attach(),
					})
				end
			end

			mason_lspconfig.setup({
				automatic_installation = true,
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
		end,
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"j-hui/fidget.nvim", -- virtual text in bottom right as loading
			"b0o/schemastore.nvim", -- json schemas
		},
		lazy = false,
	},
}

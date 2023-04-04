local status_ok, lsp = pcall(require, 'lsp-zero')
if not status_ok then
    print("LSP-ZERO could not be found or installed")
    return
end

local status_ok_neodev, neodev = pcall(require, 'neodev')
if not status_ok_neodev then
    print("neodev could not be found or installed")
    return
end
-- Setup neovim lua configuration
neodev.setup()

local status_ok_mason, mason = pcall(require, 'mason')
if not status_ok_mason then
    print("mason could not be found or installed")
    return
end
-- Setup mason so it can manage external tooling
mason.setup()

local status_ok_fidget, fidget = pcall(require, 'fidget')
if not status_ok_fidget then
    print("fidget could not be found or installed")
    return
end
-- Turn on lsp status information
fidget.setup()

-- checkout https://github.com/ThePrimeagen/init.lua/blob/master/after/plugin/lsp.lua for a more customized setup
-- nvim-cmp setup
local status_ok_cmp, cmp = pcall(require, 'cmp')
if not status_ok_cmp then
    print("cmp could not be found or installed")
    return
end

local status_ok_luasnip, luasnip = pcall(require, 'luasnip')
if not status_ok_luasnip then
    print("luasnip could not be found or installed")
    return
end

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    local builtin = require('telescope.builtin')

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
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
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    rust_analyzer = {
        cmd = {
            "rustup", "run", "stable", "rust-analyzer"
        }
    },
    -- tsserver = {},

    sumneko_lua = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            -- Fix Undefined global 'vim'
            diagnostics = {
                globals = { 'vim' }
            }
        },
    },
}

lsp.preset('recommended')
lsp.ensure_installed({
    'tsserver',
    'eslint',
    'sumneko_lua',
    'rust_analyzer',
})

--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],

            cmd = (server_name == 'rust_analyzer') and { "rustup", "run", "stable", "rust-analyzer" } or {}
        }
    end,
}


-- lsp.set_preferences({
--     suggest_lsp_servers = false,
--     sign_icons = {
--         error = 'E',
--         warn = 'W',
--         hint = 'H',
--         info = 'I'
--     }
-- })
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {

        -- ThePrimeagen section start
        -- local cmp_select = { behavior = cmp.SelectBehavior.Select }
        -- local cmp_mappings = lsp.defaults.cmp_mappings({
        --     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        --     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        --     ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        --     ["<C-Space>"] = cmp.mapping.complete(),
        -- })
        -- -- disable completion with tab
        -- -- this helps with copilot setup
        -- cmp_mappings['<Tab>'] = nil
        -- cmp_mappings['<S-Tab>'] = nil
        -- ThePrimeagen section end
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}

lsp.setup()
vim.diagnostic.config({ virtual_text = true, })

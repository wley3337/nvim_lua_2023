local M = {}

M.setup_diagnostics = function()
    local signs = {
        {
            name = "DiagnosticSignError",
            text = "",
        },
        {
            name = "DiagnosticSignWarn",
            text = "",
        },
        {
            name = "DiagnosticSignHint",
            text = "",
        },
        {
            name = "DiagnosticSignInfo",
            text = "",
        },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, {
            texthl = sign.name,
            text = sign.text,
            numhl = "",
        })
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

M.lsp_saga_keymaps = function(bufnr)
    local utils_ok, utils = pcall(require, "core.utils")
    if not utils_ok then
        print("Util file didn't load correctly in lsp_saga_keymaps")
        return
    end

    -- lsp provider to find the cursor word definition and reference
    utils.buffer_keymap(bufnr, "n", "<leader>gr", "<cmd>Lspsaga lsp_finder<CR>")

    -- code action
    utils.buffer_keymap(bufnr, { "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

    -- show hover doc
    utils.buffer_keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>")

    -- Call hierarchy
    utils.buffer_keymap(bufnr, "n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
    utils.buffer_keymap(bufnr, "n", "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

    -- scroll down hover doc or scroll in definition preview
    utils.buffer_keymap(bufnr, "n", "<C-f>", ':lua require"lspsaga.action".smart_scroll_with_saga(1)<CR>')

    -- scroll up hover doc
    utils.buffer_keymap(bufnr, "n", "<C-b>", ':lua require"lspsaga.action".smart_scroll_with_saga(-1)<CR>')

    -- show signature help
    -- utils.("n", "gs", ':lua require"lspsaga.signaturehelp".signature_help()<CR>')

    -- rename
    -- utils.buffer_keymap(bufnr, "n", "gr", "<cmd>Lspsaga rename<CR>")

    -- peek definition
    utils.buffer_keymap(bufnr, "n", "gp", "<cmd>Lspsaga peek_definition<CR>")

    -- go to definition
    utils.buffer_keymap(bufnr, "n", "gd", "<cmd>Lspsaga goto_definition<CR>")

    -- show line diagnostics
    utils.buffer_keymap(bufnr, "n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

    -- show cursor diagnostics
    utils.buffer_keymap(bufnr, "n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

    -- Show buffer diagnostics
    utils.buffer_keymap(bufnr, "n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

    -- jump to diagnostic
    utils.buffer_keymap(bufnr, "n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
    utils.buffer_keymap(bufnr, "n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

    -- Diagnostic jump with filter like Only jump to error
    utils.buffer_keymap(bufnr, "n", "[E", function()
        require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end)
    utils.buffer_keymap(bufnr, "n", "]E", function()
        require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
    end)

    -- floating terminal
    utils.buffer_keymap(bufnr, { "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
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

        vim.keymap.set("n", keys, func, {
            buffer = bufnr,
            desc = desc,
        })
    end

    local builtin_ok, builtin = pcall(require, "telescope.builtin")
    if not builtin_ok then
        print("telescope builtin didn't load correctly in on attch keymaps")
        return
    end

    M.lsp_saga_keymaps(bufnr)

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
    -- nmap("K", vim.lsp.buf.hover, "Hover Documentation") -- covered in lsp saga key maps
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
    end, {
        desc = "Format current buffer with LSP",
    })
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

return M

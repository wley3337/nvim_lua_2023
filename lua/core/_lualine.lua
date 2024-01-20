local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    print("LUALINE could not be found or installed")
    return
end

local function fileNameAndDirectory()
    -- local filePath = vim.fn.expand("%:p:h:t")
    local file = vim.fn.expand("%t")
    return file
end

-- Set lualine as statusline
-- See `:help lualine.txt`
lualine.setup({
    options = {
        component_separators = {
            left = "|",
            right = "|",
        },
        disabled_filetypes = {
            "NvimTree",
        },
        icons_enabled = false,
        section_separators = "",
        theme = "nightfly",
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { fileNameAndDirectory },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
})

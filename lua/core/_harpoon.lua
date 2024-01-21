require('harpoon').setup()
local mark = require("harpoon.mark")

local ui = require("harpoon.ui")


vim.keymap.set("n", "<leader>b", function() mark.add_file() end)
vim.keymap.set("n", "<C-e>", function() ui.toggle_quick_menu() end)


vim.keymap.set("n", "<leader>e", ui.nav_next)
vim.keymap.set("n", "<leader>w", ui.nav_prev)

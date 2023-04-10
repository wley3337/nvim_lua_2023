require("core.pre-config")

require("core.plugins")

require("core.set")
require("core.keymap")

require("core.autogroup")

require("core.colorscheme")
require("core.nvim_ts_autotag")
require("core.treesitter")
require("core.lsp_zero")
require("core.git_signs")
require("core.git_blame")
require("core.comment")
require("core.lualine")
require("core.indent_blankline")
require("core.telescope")
require("core.neodev")
require("core.autopairs")
require("core.nvim_tree")
require("core.harpoon")
require("core.rust_tools")

-- start the command pallet file written extension
require("core.command-pallet").init()

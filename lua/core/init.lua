require("core.pre-config")

-- require("core.plugins")

require("core.lazy")
require("core.set")
require("core.keymap")

require("core.autogroup")

require("core.nvim_ts_autotag")

-- start the command pallet file written extension
require("core.command-pallet").init()

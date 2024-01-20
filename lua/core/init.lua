-- Pre Load any globals that should happen before plugins load
require("core.pre-config")
require("core.lazy")
require("core.set")
require("core.keymap")
require("core.autogroup")

-- start the command pallet file written extension
require("core.command-pallet").init()

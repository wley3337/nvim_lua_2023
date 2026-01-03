return {
	"nvim-mini/mini.hipatterns",
	version = "*",
	config = function()
		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = hipatterns.gen_highlighter.hex_color(),

				hsl_color = {
					pattern = "hsl%(%d+,? %d+,? %d+%)",
					group = function(_, match)
						local utils = require("solarized-osaka.hsl")
						local nh, ns, nl = match:match("hsl%((%d+),? (%d+),? (%d+)%)")
						local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
						local hex_color = utils.hslToHex(h, s, l)
						return hipatterns.compute_hex_color_group(hex_color, "bg")
					end,
				},
			},
		})
	end,
}

local M = {}
local util = require("solarized-osaka.util")
local hslutil = require("solarized-osaka.hsl")
local hsl = hslutil.hslToHex

local defualt_colors_solarized_osaka = {
	base0 = "#9eabac",
	base00 = "#637981",
	base01 = "#576d74",
	base02 = "#063540",
	base03 = "#002c38",
	base04 = "#001419",
	base1 = "#adb7b7",
	base2 = "#ede7d3",
	base3 = "#fdf5e2",
	base4 = "#ffffff",
	bg = "#001419",
	bg_float = "#001419",
	bg_highlight = "#002c38",
	bg_popup = "#001419",
	bg_sidebar = "#001419",
	bg_statusline = "#002c38",
	black = "#001014",
	blue = "#268bd3",
	blue100 = "#a8daff",
	blue300 = "#46acf5",
	blue500 = "#268bd3",
	blue700 = "#1a6397",
	blue900 = "#0f3856",
	border = "#001014",
	cyan = "#29a298",
	cyan100 = "#b7fefa",
	cyan300 = "#2aeddd",
	cyan500 = "#29a298",
	cyan700 = "#1a6265",
	cyan900 = "#103a3c",
	error = "#db302d",
	fg = "#839395",
	fg_float = "#839395",
	green = "#849900",
	green100 = "#d6fead",
	green300 = "#b7f900",
	green500 = "#849900",
	green700 = "#586600",
	green900 = "#2c3300",
	hint = "#29a298",
	info = "#268bd3",
	magenta = "#d23681",
	magenta100 = "#ff75b7",
	magenta300 = "#f254a0",
	magenta500 = "#d23681",
	magenta700 = "#af2668",
	magenta900 = "#541131",
	none = "NONE",
	orange = "#c94c16",
	orange100 = "#ff9165",
	orange300 = "#f74f0c",
	orange500 = "#c94c16",
	orange700 = "#a13c10",
	orange900 = "#5b220a",
	red = "#db302d",
	red100 = "#ff9a99",
	red300 = "#f55350",
	red500 = "#db302d",
	red700 = "#b7211f",
	red900 = "#570f0e",
	todo = "#6d71c4",
	violet = "#6d71c4",
	violet100 = "#cccffe",
	violet300 = "#9b9fec",
	violet500 = "#6d71c4",
	violet700 = "#484eb6",
	violet900 = "#24275a",
	warning = "#b28500",
	yellow = "#b28500",
	yellow100 = "#ffe899",
	yellow300 = "#ffbf00",
	yellow500 = "#b28500",
	yellow700 = "#664c00",
	yellow900 = "#332700",
}
local colors = {
	grey = hsl(212, 42, 24),
	light_purple = hsl(244, 45, 71),
	purple_pink = hsl(219, 31, 44),
	bright_purple = hsl(267, 67, 47),
	pink = hsl(303, 60, 61),
	light_pink = hsl(296, 81, 75),
	orange = hsl(21, 70, 50),

	-- color spec from picture
	x = "#F249C5",
	i = "#D641D9",
	light_blue = hsl(196, 93, 89),
	dark_grey = hsl(212, 35, 6),
	red = hsl(341, 62, 25),
	d = "#590C30",
	n = "#80D2F2",
	o = "#595573",
	red_2 = hsl(3, 100, 43),
	green = hsl(139, 95, 45),
	l = "#2B57D9",
	yellow300 = "#ffbf00",
	hint = "#29a298",
	green300 = "#b7f900",
	cyan300 = "#2aeddd",

	y = "#601585",
	a = "#05000D",
	b = "#482EF2",
	c = "#BF372A",
	e = "#260A1A",
	f = "#32378C",
	g = "#2D3073",
	h = "#3D64D9",
	k = "#2F3273",
	m = "#3D64D9",
}

function M.colorscheme()
	-- vim.cmd("highlight clear") -- clears all highlight groups
	-- vim.cmd("syntax reset") -- resets all syntax back to default
	vim.o.background = "dark"
	vim.g.colors_name = "ghost-shell"

	local set = vim.api.nvim_set_hl

	set(0, "Normal", { bg = colors.dark_grey, fg = colors.light_blue }) -- text
	set(0, "TermCursor", { bg = colors.purple_pink, fg = colors.light_blue }) -- text
	set(0, "Visual", { bg = colors.grey })
	set(0, "Comment", { fg = colors.grey }) -- text
	set(0, "Constant", { fg = colors.bright_purple })
	-- set(0, "String", { fg = colors.light_purple })
	set(0, "String", { fg = colors.light_blue })
	set(0, "Identifier", { fg = colors.pink })
	set(0, "Function", { fg = colors.purple_pink })
	-- set(0, "Statement", { fg = colors.red }) -- keywords it looks like
	set(0, "Statement", { fg = colors.light_purple }) -- keywords it looks like
	set(0, "Type", { fg = colors.red_2 })
	-- set(0, "Special", { fg = colors.orange })
	set(0, "Special", { fg = colors.x })
	set(0, "Error", { fg = colors.red_2, bold = true })
	set(0, "FloatBorder", { fg = colors.x })
	set(0, "TelescopeBorder", { fg = colors.x })
	set(0, "TelescopeNormal", { bg = colors.dark_grey, fg = colors.h })
end

return M

-- buffer line (top of buffer)
return {
	"akinsho/bufferline.nvim",
	config = function()
		local status_ok, bufferline = pcall(require, "bufferline")
		if not status_ok then
			return
		end
		-- see `:h bufferline-configuration` for options
		bufferline.setup({
			options = {
				enforce_regular_tabs = true,
				max_name_length = 25,
				max_prefix_length = 15,
				offsets = {
					{
						filetype = "NvimTree",
						text = "",
						text_align = "right", -- "left" "center" "right"
						separator = true,
					},
				},
				separator_style = "slant", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' }
				show_buffer_close_icons = false,
				show_close_icon = false,
				tab_size = 21,
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
	version = "^4.4",
}

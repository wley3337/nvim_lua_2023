
local status_ok, indent_blankline = pcall(require, 'indent_blankline')
if not status_ok then
	print("INDENT_BLANKLINE could not be found or installed")
	return
end
indent_blankline.setup({
  char = '┊',
  show_trailing_blankline_indent = false,
})

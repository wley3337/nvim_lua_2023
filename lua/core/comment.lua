local status_ok, comment = pcall(require, 'Comment')
if not status_ok then
	print("COMMENT could not be found or installed")
	return
end
comment.setup()

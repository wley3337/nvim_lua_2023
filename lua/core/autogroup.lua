-- blow autocmd setup is from: https://www.reddit.com/r/neovim/comments/p5is1h/how_to_open_a_file_in_the_last_place_you_editied/
-- autocommands
--- This function is taken from https://github.com/norcalli/nvim_utils
-- autocommands END
-- adapted from https://github.com/ethanholz/nvim-lastplace/blob/main/lua/nvim-lastplace/init.lua
local ignore_buftype = { "quickfix", "nofile", "help" }
local ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" }

local function run()
  if vim.tbl_contains(ignore_buftype, vim.bo.buftype) then
    return
  end

  if vim.tbl_contains(ignore_filetype, vim.bo.filetype) then
    -- reset cursor to first line
    vim.cmd [[normal! gg]]
    return
  end

  -- If a line has already been specified on the command line, we are done
  --   nvim file +num
  if vim.fn.line(".") > 1 then
    return
  end

  local last_line = vim.fn.line([['"]])
  local buff_last_line = vim.fn.line("$")

  -- If the last line is set and the less than the last line in the buffer
  if last_line > 0 and last_line <= buff_last_line then
    local win_last_line = vim.fn.line("w$")
    local win_first_line = vim.fn.line("w0")
    -- Check if the last line of the buffer is the same as the win
    if win_last_line == buff_last_line then
      -- Set line to last line edited
      vim.cmd [[normal! g`"]]
      -- Try to center
    elseif buff_last_line - last_line > ((win_last_line - win_first_line) / 2) - 1 then
      vim.cmd [[normal! g`"zz]]
    else
      vim.cmd [[normal! G'"<c-e>]]
    end
  end
end

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'FileType' }, {
  group    = vim.api.nvim_create_augroup('nvim-lastplace', {}),
  callback = run
})
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Trims trailing whitespace on lines
local trim_white_space = vim.api.nvim_create_augroup('TrimWhiteSpace', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
  group = trim_white_space,
  pattern = '*',
})

-- Uses LSP Format on save
local auto_format_lsp = vim.api.nvim_create_augroup('AutoFormatLsp', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format()
  end,
  group = auto_format_lsp,
  pattern = '*',
})

--#region Closes nvim_tree if it's the last buffer
-- Source: https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close
-- nvim-tree is also there in modified buffers so this function filter it out
local modifiedBufs = function(bufs)
  local t = 0
  for k, v in pairs(bufs) do
    if v.name:match("NvimTree_") == nil then
      t = t + 1
    end
  end
  return t
end


vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and
        vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil and
        modifiedBufs(vim.fn.getbufinfo({ bufmodified = 1 })) == 0 then
      vim.cmd "quit"
    end
  end
})
--#endregion Closes nvim_tree if it's the last buffer

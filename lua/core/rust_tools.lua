local status_ok, rt = pcall(require, 'rust-tools')
if not status_ok then
  print("rust tools could not be found or installed")
  return
end
-- setup from: https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/
rt.setup({
  server = {
    -- I might want to delete these.
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

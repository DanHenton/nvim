return {
  'terrastruct/d2-vim',
  ft = { 'd2' },
  config = function()
    -- Enable auto-formatting on save
    vim.g.d2_fmt_autosave = 1

    -- Enable diagram validation on save
    vim.g.d2_validate_autosave = 1

    -- Set the ASCII preview command mode (default to extended for nice borders)
    vim.g.d2_ascii_mode = 'extended'

    -- Enable auto ASCII render on save
    vim.g.d2_ascii_autorender = 1

    -- Add a custom keymap for the playground (in addition to the default <leader>d2 commands)
    vim.keymap.set('n', '<leader>dp', '<cmd>D2Play<cr>', { desc = '[D]2 [P]layground' })
    vim.keymap.set('n', '<leader>dv', '<cmd>D2PreviewToggle<cr>', { desc = '[D]2 Pre[v]iew Toggle' })
  end,
}

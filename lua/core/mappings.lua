local keymap = vim.keymap

-- Leader
vim.g.mapleader = " "

-- Insert
keymap.set('i', 'jj', '<Esc>')

-- Buffers
keymap.set('n', '<leader>w', ':w<CR>')

-- Navigation
keymap.set('n', '<c-k>', ':wincmd k<CR>')
keymap.set('n', '<c-j>', ':wincmd j<CR>')
keymap.set('n', '<c-h>', ':wincmd h<CR>')
keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Splits
keymap.set('n', '|', ':vsplit<CR>')
keymap.set('n', '\\', ':split<CR>')
keymap.set('n', '<leader>q', ':q<CR>')

-- Neo-tree
keymap.set('n', '<leader>e', ':Neotree left toggle reveal<CR>')

-- Bufferline
keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>')
keymap.set('n', '<s-Tab>', ':BufferLineCyclePrev<CR>')
keymap.set('n', '<c-w>', ':BufferLinePickClose<CR>')
keymap.set('n', '<c-x>', ':BufferLineCloseOthers<CR>')


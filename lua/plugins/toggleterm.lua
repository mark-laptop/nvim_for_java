return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
		config = function()
			require('toggleterm').setup({
				open_mapping = [[<c-\>]],
			})
			function _G.set_terminal_keymaps()
				local opts = {buffer = 0}
				local keymap = vim.keymap
				keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)		
				keymap.set('t', 'jk', [[<C-\><C-n>]], opts)		
				keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)		
				keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)		
				keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)		
				keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)		
				keymap.set('t', '<C-w>', [[<Cmd>wincmd w<CR>]], opts)		
			end
			vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
		end
	}
}

return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim"
		},
		config = function()
			require('telescope').setup()
			local builtin = require('telescope.builtin')
			local keymap = vim.keymap
			keymap.set('n', '<leader>ff', builtin.find_files, {})
			keymap.set('n', '<leader>fw', builtin.live_grep, {})
			keymap.set('n', '<leader>fb', builtin.buffers, {})
			keymap.set('n', '<leader>fh', builtin.help_tags, {})
		end
	}
}

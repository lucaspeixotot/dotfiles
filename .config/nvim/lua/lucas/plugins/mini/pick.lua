return {
	"echasnovski/mini.pick",
	version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local pick = require("mini.pick")
		local builtin = require("mini.pick").builtin
		require("nvim-web-devicons").setup({})

		pick.setup({})

		vim.keymap.set("n", "<leader>ff", builtin.files, {})
		vim.keymap.set("n", "<leader>fg", builtin.grep_live, {})
		vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
	end,
}

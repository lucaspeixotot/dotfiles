return {
	"echasnovski/mini.completion",
	version = "*",
	config = function()
		local completion = require("mini.completion")
		completion.setup({})
		vim.keymap.set("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
		vim.keymap.set("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
	end,
}

return {
	"echasnovski/mini.files",
	version = "*",
	config = function()
		local files = require("mini.files")
		files.setup({})
		vim.keymap.set("n", "<leader>e", ":lua MiniFiles.open()<cr>", {})
	end,
}

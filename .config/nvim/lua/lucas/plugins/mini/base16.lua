return {
	"echasnovski/mini.base16",
	version = "*",
	config = function()
		local base16 = require("mini.base16")
		vim.cmd([[colorscheme base16-onedark]])
	end,
}

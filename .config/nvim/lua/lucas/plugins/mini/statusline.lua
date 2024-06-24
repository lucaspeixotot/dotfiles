return {
	"echasnovski/mini.statusline",
	version = "*",
	config = function()
		local statusline = require("mini.statusline")
		statusline.setup({ set_vim_settings = false })
	end,
}

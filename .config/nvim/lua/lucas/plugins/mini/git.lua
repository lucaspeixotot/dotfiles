return {
	"echasnovski/mini-git",
	version = "*",
	main = "mini.git",
	config = function()
		local git = require("mini.git")
		git.setup({})
	end,
}

return {
	"echasnovski/mini.sessions",
	version = "*",
	config = function()
		local sessions = require("mini.sessions")
		sessions.setup({})
	end,
}

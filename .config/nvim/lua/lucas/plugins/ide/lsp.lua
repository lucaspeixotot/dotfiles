return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lspconfig = require("lspconfig")
		lspconfig.lua_ls.setup({})
		lspconfig.gopls.setup({})
		lspconfig.pyright.setup({})
		lspconfig.bashls.setup({})
		lspconfig.clangd.setup({})
		lspconfig.jdtl.setup({})

		vim.keymap.set("n", "gr", ":lua vim.lsp.buf.references()<cr>", {})
		vim.keymap.set("n", "gi", ":lua vim.lsp.buf.implementation()<cr>", {})
		vim.keymap.set("n", "gf", ":lua vim.lsp.buf.definition()<cr>", {})
	end,
}

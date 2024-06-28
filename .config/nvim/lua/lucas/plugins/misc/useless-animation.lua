return {
	"Eandrju/cellular-automaton.nvim",
	config = function()
		vim.keymap.set("n", "<F5>", "<cmd>CellularAutomaton make_it_rain<CR>")
		vim.keymap.set("n", "<F6>", "<cmd>CellularAutomaton game_of_life<CR>")
	end,
}

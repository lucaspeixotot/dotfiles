return {
    'rodolfojsv/reminders.nvim',
    config = function()
        require('reminders').setup { directory_path = '/home/lucas/.config/nvim/reminders' }
    end
}

return {
    'mistweaverco/kulala.nvim',
    config = function()
        require('lazy').setup({
            -- HTTP REST-Client Interface
            {
                'mistweaverco/kulala.nvim',
                config = function()
                    -- Setup is required, even if you don't pass any options
                    require('kulala').setup()
                end
            },
        })
    end


}

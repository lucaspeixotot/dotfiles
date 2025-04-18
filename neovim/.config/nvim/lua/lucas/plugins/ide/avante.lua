return {
    "yetone/avante.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        {
            "MeanderingProgrammer/render-markdown.nvim",
            opts = { file_types = { "markdown", "Avante" } },
            ft = { "markdown", "Avante" },
        },
    },
    build = "make",
    opts = function()
        local hostname = vim.loop.os_gethostname()
        local is_hpedev = hostname == "hpedev"

        if is_hpedev then
            return { provider = "copilot" }
        else
            return {
                provider = "openrouter",
                ollama = {
                    endpoint = "http://192.168.15.20:11434",
                    model = "deepseek-coder:6.7b",
                },
                vendors = {
                    openrouter = {
                        __inherited_from = 'openai',
                        endpoint = 'https://openrouter.ai/api/v1',
                        api_key_name = 'OPENROUTER_API_KEY',
                        -- model = 'deepseek/deepseek-r1',
                        model = 'anthropic/claude-3.5-sonnet',
                        max_tokens = 8192,
                        disable_tools = true,
                    },

                },
            }
        end
    end,
}

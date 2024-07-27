return {
    'echasnovski/mini.sessions',
    version = '*',
    config = function()
        local sessions = require("mini.sessions")
        local home = os.getenv("HOME")
        local sessions_dir = home .. "/.config/nvim/sessions"
        sessions.setup({
            directory = sessions_dir
        })

        local sessions_save = function()
            local current_session = vim.v.this_session
            if current_session ~= "" then
                vim.notify("There is a current session: " .. current_session)
                return
            end

            local name = vim.fn.input("Enter the new session name: ")
            if name == "" then
                vim.notify("Operation canceled")
                return
            end
            sessions.write(name)
            vim.cmd("redraw")
            vim.notify("Session " .. name .. " saved")
        end

        local sessions_delete = function()
            local name = vim.fn.input("Enter the target session to be deleted: ")
            if name == "" then
                vim.notify("Operation canceled")
                return
            end
            sessions.delete(name)
            vim.cmd("redraw")
            vim.notify("Session " .. name .. " deleted")
        end

        nmap_leader(
            "sn",
            function()
                sessions_save()
            end,
            "Save session"
        )

        nmap_leader(
            "sd",
            function()
                sessions_delete()
            end,
            "Delete session"
        )

        nmap_leader(
            "ss",
            function()
                sessions.select()
            end,
            "Select session"
        )
    end

}

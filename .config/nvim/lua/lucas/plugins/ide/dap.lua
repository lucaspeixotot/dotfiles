return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "mfussenegger/nvim-dap-python",
    },
    config = function()
        local dap_client = require("dap")
        local dap_python = require("dap-python")
        dap_python.setup()
        dap_python.test_runner = "pytest"

        nmap('<F9>', function() dap_client.continue() end, 'Debug continue')
        nmap('<F10>', function() dap_client.step_over() end, 'Debug step over')
        nmap('<F11>', function() dap_client.step_into() end, 'Debug step into')
        nmap('<F12>', function() dap_client.step_out() end, 'Debug step out')
        nmap_leader('dt', function() dap_client.toggle_breakpoint() end, 'Toggle breakpoint')
        nmap_leader('df', function() dap_python.test_method() end, 'Test method')
        nmap_leader('dc', function() dap_python.test_class() end, 'Test class')
        nmap_leader('ds', function() dap_python.debug_selection() end, 'Debug selection')
    end
}

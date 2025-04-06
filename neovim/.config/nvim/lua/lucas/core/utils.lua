_G.nmap_g = function(suffix, rhs, desc)
    vim.keymap.set('n', 'g' .. suffix, rhs, { desc = desc })
end

_G.nmap = function(mapping, rhs, desc)
    vim.keymap.set('n', mapping, rhs, { desc = desc })
end

_G.vmap = function(mapping, rhs, desc)
    vim.keymap.set('v', mapping, rhs, { desc = desc })
end

_G.nmap_leader = function(suffix, rhs, desc)
    vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end

_G.vmap_leader = function(suffix, rhs, desc)
    vim.keymap.set('v', '<Leader>' .. suffix, rhs, { desc = desc })
end

_G.toggle_relative_number = function()
    local current = vim.wo.relativenumber
    local next = true
    if current == true then
        next = false
    end
    vim.wo.relativenumber = next
end

_G.open_config_tab = function()
    vim.cmd("tabnew")
    vim.cmd("cd ~/.config/nvim")
    vim.cmd("edit ~/.config/nvim")
end

_G.update_cwd = function()
    local current_file_dir = vim.fn.expand("%:p:h")
    local new_cwd = vim.fn.input("Enter new directory: ", current_file_dir)
    vim.cmd("cd " .. new_cwd)
    vim.cmd("redraw")
    vim.notify("Changed CWD to: " .. new_cwd)
end

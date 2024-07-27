_G.nmap_g = function(suffix, rhs, desc)
    vim.keymap.set('n', 'g' .. suffix, rhs, { desc = desc })
end

_G.nmap_leader = function(suffix, rhs, desc)
    vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end

_G.vmap_leader = function(suffix, rhs, desc)
    vim.keymap.set('v', '<Leader>' .. suffix, rhs, { desc = desc })
end

vim.g.conflict_marker_enable_highlight = 1
vim.g.conflict_marker_begin            = "^<<<<<<< \\@="
vim.g.conflict_marker_common_ancestors = "^||||||| .*$"
vim.g.conflict_marker_separator        = "^=======$"
vim.g.conflict_marker_end              = "^>>>>>>> \\@="
vim.cmd[[
highlight ConflictMarkerBegin guifg=#e06c75
highlight ConflictMarkerOurs guibg=#2e5049
highlight ConflictMarkerSeparator guifg=#e06c75
highlight ConflictMarkerTheirs guibg=#344f69
highlight ConflictMarkerEnd guifg=#e06c75
]]

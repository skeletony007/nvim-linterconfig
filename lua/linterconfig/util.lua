local M = {}

M.default_config = {
    autostart = function(self, source)
        local directory = vim.fs.root(source, self.root_markers)
        if directory == nil then
            return false
        end
        return true
    end,
}

return M

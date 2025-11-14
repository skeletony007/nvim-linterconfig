local M = {}

M.default_config = {
    autostart = function(self, source)
        if self.root_markers == nil then
            return true
        end

        local directory = vim.fs.root(source, self.root_markers)
        if directory == nil then
            return false
        end
        return true
    end,
}

return M

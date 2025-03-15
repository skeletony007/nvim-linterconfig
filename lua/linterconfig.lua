local configs = require("linterconfig.configs")

M = {}

--- Deprecated config names.
---
---@class Alias
---@field to string The new name of the server
---@field version string The version that the alias will be removed in
---@field inconfig? boolean should display in healthcheck (`:checkhealth linterconfig`)
local aliases = {
    ["example"] = {
        to = "new_example",
        version = "0.2.1",
    },
}

---@return Alias
---@param name string|nil get this alias, or nil to get all aliases that were used in the current session.
M.server_aliases = function(name)
    if name then
        return aliases[name]
    end
    local used_aliases = {}
    for sname, alias in pairs(aliases) do
        if alias.inconfig then
            used_aliases[sname] = alias
        end
    end
    return used_aliases
end

local mt = {}
function mt:__index(k)
    if configs[k] == nil then
        local alias = M.server_aliases(k)
        if alias then
            vim.deprecate(k, alias.to, alias.version, "nvim-linterconfig", false)
            alias.inconfig = true
            k = alias.to
        end

        local success, config = pcall(require, "linterconfig.configs." .. k)
        if success then
            configs[k] = config
        else
            vim.notify(string.format('[linterconfig] config "%s" not found.', k), vim.log.levels.WARN)
            -- Return a dummy function for compatibility with user configs
            return { setup = function() end }
        end
    end
    return configs[k]
end

return setmetatable(M, mt)

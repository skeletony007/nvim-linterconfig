local configs = {}

local util = require("linterconfig.util")
local api = vim.api
local tbl_deep_extend, tbl_filter, tbl_contains = vim.tbl_deep_extend, vim.tbl_filter, vim.tbl_contains

local lint = require("lint")

--- @class linterconfig.Config
--- @field name? string
--- @field filetypes? string[]
--- @field root_markers? string[]
--- @field autostart? fun(self: table, source: integer|string)

---@param t table
---@param config_name string
---@param config_def table Config definition read from `linterconfig.configs.<name>`.
function configs.__newindex(t, config_name, config_def)
    local M = {}

    local default_config = tbl_deep_extend("keep", config_def.default_config, util.default_config)

    -- Force this part.
    default_config.name = config_name

    --- @param user_config linterconfig.Config
    function M.setup(user_config)
        user_config = user_config or {}

        local linter_group = api.nvim_create_augroup("linterconfig", { clear = false })

        local config = tbl_deep_extend("keep", user_config, default_config)

        ---@param opts table options dict for api.nvim_create_autocmd containing opts.buf
        local function update_linter(opts)
            local ft = vim.bo[opts.buf].filetype
            if tbl_contains(config.filetypes, ft) == false then
                return
            end

            if config.autostart(config, opts.buf) == true then
                lint.linters_by_ft[ft] =
                    tbl_deep_extend("keep", { config.name }, lint.linters_by_ft[ft] or {})
            elseif lint.linters_by_ft[ft] then
                local filtered = tbl_filter(
                    function(entry) return entry ~= config.name end,
                    lint.linters_by_ft[ft]
                )
                if #filtered == 0 then
                    lint.linters_by_ft[ft] = nil
                else
                    lint.linters_by_ft[ft] = filtered
                end
            end
        end

        api.nvim_create_autocmd("BufEnter", {
            callback = update_linter,
            group = linter_group,
            desc = string.format("Checks whether linter %s should start and updates nvim-lint.", config.name),
        })
        update_linter({ buf = api.nvim_get_current_buf() })
    end

    rawset(t, config_name, M)
end

return setmetatable({}, configs)

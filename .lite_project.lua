local config = require "core.config"

local lite_globals = {
  "PLATFORM", "SCALE",
  "renderer", "system",
}

config.lint.luacheck_args = {}
for _, global in ipairs(lite_globals) do
  table.insert(config.lint.luacheck_args, "--globals")
  table.insert(config.lint.luacheck_args, global)
end

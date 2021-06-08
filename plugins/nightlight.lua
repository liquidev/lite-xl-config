-- lite-xl 1.16

local core = require "core"
local config = require "core.config"
local RootView = require "core.rootview"

-- WARNING! by default, this uses a module user.colors.default which is NOT
-- preinstalled with lite. creating this module is as simple as adapting
-- the colors defined in core.style
config.day_theme = "colors.noctis-lilac"
config.night_theme = "colors.ayu-mirage"

config.day_hours = { start = 7, fin = 18 }

local function get_time_of_day()
  local time = os.date("*t")
  return time.hour + time.min / 60 + time.sec / 3600
end

local update = RootView.update

local nightlight = {
  current_theme = "",
  on_switch = function () end
}

function RootView:update(...)
  update(self, ...)

  local hour = get_time_of_day()
  if hour >= config.day_hours.start and hour <= config.day_hours.fin then
    if nightlight.current_theme ~= "day" then
      package.loaded[config.day_theme] = nil
      core.reload_module(config.day_theme)
      nightlight.current_theme = "day"
      nightlight.on_switch()
    end
  else
    if nightlight.current_theme ~= "night" then
      package.loaded[config.night_theme] = nil
      core.reload_module(config.night_theme)
      nightlight.current_theme = "night"
      nightlight.on_switch()
    end
  end
end

return nightlight

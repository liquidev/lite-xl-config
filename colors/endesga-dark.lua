-- Colors from ENDESGA's EDG32 palette.

local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#181425" }
style.background2 = { common.color "#181425" }
style.background3 = { common.color "#181425" }
style.text = { common.color "#c0cbdc" }
style.caret = { common.color "#ffffff" }
style.accent = { common.color "#ff0044" }
style.dim = { common.color "#8b9bb4" }
style.divider = { common.color "#262b44" }
style.selection = { common.color "#262b44" }
style.line_number = { common.color "#5a6988" }
style.line_number2 = { common.color "#8b9bb4" }
style.line_highlight = { common.color "#262b44" }
style.scrollbar = { common.color "#5a6988" }
style.scrollbar2 = { common.color "#8b9bb4" }

style.syntax["normal"] = { common.color "#FFFFFF" }
style.syntax["symbol"] = { common.color "#FFFFFF" }
style.syntax["comment"] = { common.color "#8b9bb4" }
style.syntax["keyword"] = { common.color "#feae34" }
style.syntax["keyword2"] = { common.color "#2ce8f5" }
style.syntax["number"] = { common.color "#f6757a" }
style.syntax["literal"] = { common.color "#f6757a" }
style.syntax["string"] = { common.color "#63c74d" }
style.syntax["operator"] = { common.color "#feae34" }
style.syntax["function"] = { common.color "#fee761" }

-- lint+ support
style.lint = {
  info = style.syntax["keyword2"],
  hint = style.syntax["function"],
  warning = style.syntax["function"],
  error = { common.color "#FF3333" }
}

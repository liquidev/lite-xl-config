local style = require "core.style"
local common = require "core.common"

local pal = {
  gray0  = { common.color "#18191f" },
  gray1  = { common.color "#292b36" },
  gray2  = { common.color "#353845" },
  gray3  = { common.color "#494d5c" },
  gray4  = { common.color "#7d7f8a" },
  white  = { common.color "#f5f5ef" },
  red    = { common.color "#ff4284" },
  yellow = { common.color "#ffff66" },
  green  = { common.color "#a7f36d" },
  blue   = { common.color "#64d2fa" },
  pink   = { common.color "#ff86f8" },
}

style.background = pal.gray1
style.background2 = pal.gray0
style.background3 = pal.gray0
style.text = pal.gray4
style.caret = pal.white
style.accent = pal.red
style.dim = pal.gray3
style.divider = pal.gray1
style.selection = pal.gray2
style.line_number = pal.gray3
style.line_number2 = pal.gray4
style.line_highlight = pal.gray2
style.scrollbar = pal.gray2
style.scrollbar2 = pal.gray3

style.syntax["normal"] = pal.black
style.syntax["symbol"] = pal.black
style.syntax["comment"] = pal.gray4
style.syntax["keyword"] = pal.red
style.syntax["keyword2"] = pal.blue
style.syntax["number"] = pal.pink
style.syntax["literal"] = pal.pink
style.syntax["string"] = pal.green
style.syntax["operator"] = pal.red
style.syntax["function"] = pal.yellow

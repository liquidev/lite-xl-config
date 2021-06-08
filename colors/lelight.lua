local style = require "core.style"
local common = require "core.common"

local pal = {
  gray0  = { common.color "#615340" },
  gray1  = { common.color "#7d7355" },
  gray2  = { common.color "#c7bea7" },
  gray3  = { common.color "#e6e2d3" },
  gray4  = { common.color "#f5f1e1" },
  white  = { common.color "#fffdef" },
  black  = { common.color "#100820" },
  red    = { common.color "#ed1447" },
  yellow = { common.color "#d17400" },
  green  = { common.color "#43911f" },
  blue   = { common.color "#2d7ad1" },
  pink   = { common.color "#b92fb2" },
}

style.background = pal.white
style.background2 = pal.gray3
style.background3 = pal.gray4
style.text = pal.gray0
style.caret = pal.black
style.accent = pal.red
style.dim = pal.gray2
style.divider = pal.gray2
style.selection = pal.gray3
style.line_number = pal.gray2
style.line_number2 = pal.gray1
style.line_highlight = pal.gray3
style.scrollbar = pal.gray3
style.scrollbar2 = pal.gray2
-- awdawd
style.syntax["normal"] = pal.black
style.syntax["symbol"] = pal.black
style.syntax["comment"] = pal.gray1
style.syntax["keyword"] = pal.red
style.syntax["keyword2"] = pal.blue
style.syntax["number"] = pal.pink
style.syntax["literal"] = pal.pink
style.syntax["string"] = pal.green
style.syntax["operator"] = pal.red
style.syntax["function"] = pal.yellow


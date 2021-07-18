local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#FAFAFA" }
style.background2 = { common.color "#FFFFFF" }
style.background3 = { common.color "#FFFFFF" }
style.text = { common.color "#232629" }
style.caret = { common.color "#FF7700" }
style.accent = { common.color "#FF7700" }
style.dim = { common.color "#3A3F45" }
style.divider = { common.color "#e7e7e7" }
style.selection = { common.color "#B7C7DD" }
style.line_number = { common.color "#c0c2c4" }
style.line_number2 = { common.color "#72767a" }
style.line_highlight = { common.color "#F1F3F6" }
style.scrollbar = { common.color "#c0c2c4" }
style.scrollbar2 = { common.color "#c0c2c4" }

style.syntax["normal"] = { common.color "#232629" }
style.syntax["symbol"] = { common.color "#232629" }
style.syntax["comment"] = { common.color "#ABB0B6" }
style.syntax["keyword"] = { common.color "#F96B06" }
style.syntax["keyword2"] = { common.color "#1673B6" }
style.syntax["number"] = { common.color "#8046B9" }
style.syntax["literal"] = { common.color "#8046B9" }
style.syntax["string"] = { common.color "#608000" }
style.syntax["operator"] = { common.color "#E45E1B" }
style.syntax["function"] = { common.color "#EE9611" }

-- lint+ support
style.lint = {
  info = style.syntax["keyword2"],
  hint = style.syntax["function"],
  warning = style.syntax["function"],
  error = { common.color "#F51818" }
}

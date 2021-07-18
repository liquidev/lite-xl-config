local style = require "core.style"
local common = require "core.common"

style.background = { common.color "#FAFAFA" }
style.background2 = { common.color "#FAFAFA" }
style.background3 = { common.color "#FAFAFA" }
style.text = { common.color "#575F66" }
style.caret = { common.color "#FF9400" }
style.accent = { common.color "#FF9400" }
style.dim = { common.color "#8A9199" }
style.divider = { common.color "#E7E8E9" }
style.selection = { common.color "#E7E8E9" }
style.line_number = { common.color "#d1d5d8" }
style.line_number2 = { common.color "#a9afb6" }
style.line_highlight = { common.color "#f2f2f2" }
style.scrollbar = { common.color "#d1d5d8" }
style.scrollbar2 = { common.color "#d1d5d8" }

style.syntax["normal"] = { common.color "#575F66" }
style.syntax["symbol"] = { common.color "#575F66" }
style.syntax["comment"] = { common.color "#ABB0B6" }
style.syntax["keyword"] = { common.color "#FA8D3E" }
style.syntax["keyword2"] = { common.color "#399EE6" }
style.syntax["number"] = { common.color "#A37ACC" }
style.syntax["literal"] = { common.color "#A37ACC" }
style.syntax["string"] = { common.color "#86B300" }
style.syntax["operator"] = { common.color "#ED9366" }
style.syntax["function"] = { common.color "#F2AE49" }

-- lint+ support
style.lint = {
  info = style.syntax["keyword2"],
  hint = style.syntax["function"],
  warning = style.syntax["function"],
  error = { common.color "#F51818" }
}

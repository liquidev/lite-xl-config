-- lite-xl 1.16

local config = require "core.config"
local style = require "core.style"
local DocView = require "core.docview"

local draw_line_text = DocView.draw_line_text

config.trailing_whitespace_repr = {
  default = '·',
  ['\t'] = '» ',
}

function DocView:draw_line_text(idx, x, y)
  draw_line_text(self, idx, x, y)

  local text = self.doc.lines[idx]

  local start, fin = text:find('%s+$')
  if start - fin == 0 then return end

  local start_x = x + self:get_col_x_offset(idx, start)
  local fin_x = x + self:get_col_x_offset(idx, fin)
  local y_offset = self:get_line_text_y_offset()

  local background_color = style.background
  local text_color = style.trailing_whitespace or style.syntax["comment"]
  local start_line, _, fin_line, _ = self.doc:get_selection(true)

  local font = self:get_font()
  local ss = font:subpixel_scale()
  local xx = start_x * ss
  for i = start, fin - 1 do
    local c = text:sub(i, i)
    local r = config.trailing_whitespace_repr[c] or config.trailing_whitespace_repr.default
    xx = renderer.draw_text_subpixel(font, r, xx, y + y_offset, text_color)
  end
end

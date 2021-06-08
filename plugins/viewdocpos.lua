-- lite-xl 1.16

-- simple plugin for remembering the line/column per DocView and not just
-- per document.

local core = require "core"

local DocView = require "core.docview"

local function save_position_in_view(view)
  if not view:is(DocView) then return end

  local doc = view.doc
  local s = doc.selection
  if view.__doc_selection == nil then
    view.__doc_selection = { a = {}, b = {} }
  end
  local ds = view.__doc_selection
  ds.a.line, ds.a.col = s.a.line, s.a.col
  ds.b.line, ds.b.col = s.b.line, s.b.col
end

local function restore_position_from_view(view)
  if not view:is(DocView) then return end

  local doc = view.doc
  local ds = view.__doc_selection
  local s = doc.selection
  if ds then
    s.a.line, s.a.col = ds.a.line, ds.a.col
    s.b.line, s.b.col = ds.b.line, ds.b.col
  end
end

local core_set_active_view = core.set_active_view
function core.set_active_view(view)
  if core.active_view ~= view and
     getmetatable(core.active_view) == DocView and
     getmetatable(view) == DocView then
    save_position_in_view(core.active_view)
    restore_position_from_view(view)
  end

  core_set_active_view(view)
end

local core = require "core"
local keymap = require "core.keymap"
local config = require "core.config"
local style = require "core.style"
local command = require "core.command"
local common = require "core.common"

local DocView = require "core.docview"
local RootView = require "core.rootview"

-- consts
local HomeDir = "/home/daknus"

-- font
local sans = "Lato-Regular.ttf"
local mono = "SourceCodePro-Medium.ttf"
local mono_italic = "SourceCodePro-MediumItalic.ttf"
local mono_bold = "SourceCodePro-Bold.ttf"

local code_config = {
  antialiasing = "subpixel",
  hinting = "slight",
}

local nightlight = require "plugins.nightlight"

local function update_font_overrides()
  style.syntax_fonts["comment"] = style.italic_font
  style.syntax_fonts["keyword2"] = style.italic_font
  if nightlight.current_theme == "day" then
    style.syntax_fonts["operator"] = style.bold_font
  else
    style.syntax_fonts["operator"] = nil
  end
end

local function load_fonts(sans_size, big_sans_size, code_size)
  style.font = renderer.font.load(HomeDir.."/.fonts/"..sans, sans_size * SCALE, { antialiasing = "subpixel" })
  style.big_font = renderer.font.load(HomeDir.."/.fonts/"..sans, big_sans_size * SCALE)
  style.code_font = renderer.font.load(HomeDir.."/.fonts/"..mono, code_size * SCALE, code_config)
  style.italic_font = renderer.font.load(HomeDir.."/.fonts/"..mono_italic, code_size * SCALE, code_config)
  style.bold_font = renderer.font.load(HomeDir.."/.fonts/"..mono_bold, code_size * SCALE, code_config)
  update_font_overrides()
end

style.caret_width = common.round(2 * SCALE)
style.padding = { x = 14, y = 7 }
config.line_height = 1.2

function nightlight.on_switch()
  style.trailing_whitespace = style.syntax["comment"]
  update_font_overrides()
end

-- config

core.reload_module "colors.ayu-mirage"
load_fonts(13, 32, 13)

config.fps = 144
config.message_timeout = 1
config.blink_period = 1.0
config.animation_rate = 1.0
config.max_tabs = 9

config.lint = {}
config.lint.lens_style = "solid"

config.trimwhitespace = true

-- commands

local function doc()
  return core.active_view.doc
end

local function get_indent_string()
  if config.tab_type == "hard" then
    return '\t'
  end
  return (' '):rep(config.indent_size)
end

local function smart_indent(text)
  local line1, col1, line2, col2, swap = doc():get_selection(true)
  for line = line1, line2 do
    local line_text = doc().lines[line]
    if line_text:find("%S") then
      doc():insert(line, 1, text)
    end
  end
  doc():set_selection(line1, col1 + #text, line2, col2 + #text, swap)
end

command.add("core.docview", {
  ["doc:center-vertically"] = function ()
    local view = core.active_view
    local line, _ = view.doc:get_selection()
    local center_y = view.size.y / 2
    local _, destination_y = view:get_line_screen_position(line)
    local delta = destination_y - center_y
    view.scroll.to.y = view.scroll.to.y + delta
  end,

  ["doc:smart-indent"] = function ()
    smart_indent(get_indent_string())
  end,
})

command.add(nil, {
  ["core:set-font-size"] = function ()
    core.command_view:enter("Font size", function (new_size)
      local ok, val = pcall(tonumber, new_size)
      if ok then
        load_fonts(13, 32, val)
      else
        core.error(val)
      end
    end)
  end,
})

-- keybinds
keymap.add {
  ["ctrl+shift+c"] = "doc:center-vertically",
  ["ctrl+]"]       = "doc:smart-indent",
  ["ctrl+["]       = "doc:unindent",
  ["alt+up"]       = "doc:move-lines-up",
  ["alt+down"]     = "doc:move-lines-down",
  ["ctrl+e"]       = "core:find-file",
  ["ctrl+q"]       = "core:quit",
}

-- hide tree by default
core.add_thread(function ()
  command.perform("treeview:toggle")
end)

-- lint+

local lintplus = require "plugins.lintplus"
lintplus.setup.lint_on_doc_load()
lintplus.setup.lint_on_doc_save()
lintplus.enable_async()

-- LSP

local lsp = require "plugins.lsp"
lsp.add_server {
  name = "lua_language_server",
  language = "lua",
  file_patterns = { "%.lua$" },
  command = {
    "/home/daknus/Repositories/lua-language-server/build/linux/bin/lua",
    "-E",
    "/home/daknus/Repositories/lua-language-server/main.lua",
    "-e", "LANG=en",
  },
  -- verbose = true,
  settings = {
    Lua = {
      completion = {
        enable = true,
        keywordSnippet = "Disable"
      },
      develop = {
        enable = false,
        debuggerPort = 11412,
        debuggerWait = false
      },
      diagnostics = {
        enable = false,
      },
      hover = {
        enable = true,
        viewNumber = true,
        viewString = true,
        viewStringMax = 1000
      },
      runtime = {
        version = 'Lua 5.4',
        path = {
          "?.lua",
          "?/init.lua",
          "?/?.lua",
          "/usr/share/5.4/?.lua",
          "/usr/share/lua/5.4/?/init.lua"
        }
      },
      signatureHelp = {
        enable = true
      },
      workspace = {
        maxPreload = 2000,
        preloadFileSize = 1000
      }
    }
  },
}

config.lsp.show_diagnostics = false

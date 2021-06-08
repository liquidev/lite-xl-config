-- lite-xl 1.16

-- MIT License
--
-- Copyright (c) 2021 liquidev
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- the parser used in this plugin is quite crude, but does the job pretty well.
-- the following keys are supported:
--   · indent_style = (tab|space) - sets config.tab_type
--   · indent_size = <integer> – sets config.indent_size
--   · end_of_line = (lf|crlf) – sets LF or CRLF for Docs
--     note: `cr` is not supported due to limitations of lite
--   · max_line_length = <integer> - nonstandard, sets config.line_limit
-- currently unsupported, but planned:
--   · trim_trailing_whitespace - *might* be impossible to disable
--   · insert_final_newline
-- not supported and not planned:
--   · charset

local common = require "core.common"
local config = require "core.config"
local core = require "core"
local Doc = require "core.doc"
local DocView = require "core.docview"


----
-- CONFIG PER DOCUMENT
----


local active_doc = nil


-- set up Doc to contain config table
local doc_reset = Doc.reset
function Doc.reset(self, ...)
  doc_reset(self, ...)
  self.config = {}
end

-- set up config to not contain supported fields, so that __index for those
-- keys is always triggered

local capture_keys = {
  indent_size = true,
  tab_type = true,
  line_limit = true,
}

local global_config = {}

for key, _ in pairs(capture_keys) do
  global_config[key] = config[key]
  config[key] = nil
end

local function get_active_doc()
  if active_doc then
    return active_doc
  else
    if core.active_view.doc then
      return core.active_view.doc
    end
  end
  return nil
end

do
  local mt = getmetatable(config) or {}

  mt.__index = function (t, key)
    local doc = get_active_doc()
    if capture_keys[key] then
      if doc ~= nil and doc.config and doc.config[key] ~= nil then
        return doc.config[key]
      else
        return global_config[key]
      end
    else
      return rawget(t, key)
    end
  end

  mt.__newindex = function (t, key, value)
    if capture_keys[key] then
      global_config[key] = value
    else
      rawset(t, key, value)
    end
  end

  setmetatable(config, mt)
end

-- DocView draw hook so that switching between files with different settings
-- doesn't look odd

core.add_thread(function ()
  -- we do this in a thread to make sure all other plugins have injected their
  -- code already
  local docview_draw = DocView.draw
  function DocView.draw(self)
    local previous_active_doc = active_doc
    active_doc = self.doc
    docview_draw(self)
    active_doc = previous_active_doc
  end
end)


----
-- CORE
----


local function parse_editorconfig(text)

  local function strip_whitespace(str)
    return str:match("%s*(.-)%s*$") or ""
  end

  local result = {
    preamble = {},
    sections = {},
  }
  local section = nil

  for unstripped_line in text:gmatch("([^\r\n]+)\r?\n") do
    local line = strip_whitespace(unstripped_line)
    -- skip empty lines and comments
    if #line > 0 and not line:match("^[;#]") then
      -- sections
      local matched_section = line:match("^%[(.-)%]$")
      if matched_section then
        section = matched_section
        result.sections[section] = result.sections[section] or {}
      end
      -- key-value pairs
      local key, value = line:match("^(.-)=(.-)$")
      if key then
        key, value = strip_whitespace(key):lower(), strip_whitespace(value)
        if section then
          result.sections[section][key] = value
        else
          result.preamble[key] = value
        end
      end
    end
  end

  return result

end


----
-- CORE: GLOB PATTERNS
----


local special_pattern_chars = {
  ['^'] = true,
  ['$'] = true,
  ['('] = true,
  [')'] = true,
  ['%'] = true,
  ['.'] = true,
  ['['] = true,
  [']'] = true,
  ['*'] = true,
  ['+'] = true,
  ['-'] = true,
  ['?'] = true,
}

local function escape_pattern_char(char)
  if special_pattern_chars[char] then
    return '%' .. char
  else
    return char
  end
end

local function compile_glob_pattern(glob_pattern)

  local function expand_braces(glob)

    local r = {}

    -- parse the glob to find left and right braces, and all available
    -- expansions
    local left, right = -1, -1
    local level = 0
    local expansions = {}
    local expansion = {}
    for i = 1, #glob do
      local char = glob:sub(i, i)
      if char == '{' then
        level = level + 1
        if level == 1 then left = i end
      elseif char == '}' then
        if level == 1 then
          right = i
          table.insert(expansions, table.concat(expansion))
          break
        end
        level = level - 1
      elseif char == ',' and level == 1 then
        table.insert(expansions, table.concat(expansion))
        expansion = {}
      elseif level >= 1 then
        table.insert(expansion, char)
      end
    end
    -- if there weren't any braces, simply return the glob
    if left == -1 or right == -1 then
      return {glob}, false
    -- otherwise split the pattern into parts before { and after }, and
    -- expand recursively
    else
      local before = glob:sub(1, left - 1)
      local after = glob:sub(right + 1)
      for _, exp in ipairs(expansions) do
        -- check whether the expansion is a range
        local min, max = exp:match("([%-+]?%d+)%.%.([%-+]?%d+)")
        if min then
          min, max = tonumber(min), tonumber(max)
          local step = (min <= max) and 1 or -1
          for i = min, max, step do
            local expanded = before .. i .. after
            table.insert(r, expanded)
          end
        else
          local expanded = before .. exp .. after
          table.insert(r, expanded)
        end
      end
    end

    local result = {}

    for _, subglob in ipairs(r) do
      local expanded = expand_braces(subglob)
      for _, exp in ipairs(expanded) do
        table.insert(result, exp)
      end
    end

    return result, true

  end

  local function glob_pattern_to_lua_pattern(glob)

    local result = {}
    local i = 1
    local is_path = false

    local function get()
      return glob:sub(i, i)
    end

    while i <= #glob do
      local char = get()

      -- wildcards
      if char == '*' then
        local all = false
        i = i + 1
        if get() == '*' then
          all = true
        end
        if all then
          table.insert(result, '.-')
        else
          table.insert(result, '[^/]-')
        end
      elseif char == '?' then
        table.insert(result, '.')

      -- character sets
      elseif char == '[' then
        local set = ""
        local invert = false
        i = i + 1
        if get() == '!' then
          invert = true
          i = i + 1
        end
        while get() ~= ']' do
          set = set .. escape_pattern_char(get())
          i = i + 1
        end
        i = i + 1
        table.insert(result, (invert and "[^" or "[") .. set .. "]")

      -- escapes
      elseif char == '\\' then
        i = i + 1
        local escaped = escape_pattern_char(get())
        i = i + 1
        table.insert(result, escaped)

      -- anything else
      else
        if char == '/' then
          is_path = true
        end
        table.insert(result, escape_pattern_char(char))
        i = i + 1
      end

    end

    local str = table.concat(result)
    if not is_path then
      str = '^' .. str .. '$'
    end
    return str, is_path

  end

  local patterns = expand_braces(glob_pattern)
  for i, pattern in ipairs(patterns) do
    local lua_pattern, is_path = glob_pattern_to_lua_pattern(pattern)
    patterns[i] = lua_pattern
    if is_path then
      patterns.is_path = true
    end
  end

  return patterns

end

local function compile_patterns_in_editorconfig(editorconfig)

  local compiled_patterns = {}
  for glob, _ in pairs(editorconfig.sections) do
    compiled_patterns[glob] = compile_glob_pattern(glob)
  end

  for glob, pattern in pairs(compiled_patterns) do
    local section = editorconfig.sections[glob]
    editorconfig.sections[glob] = nil
    editorconfig.sections[pattern] = section
  end

end

local cached_editorconfigs = {}

local function load_editorconfig(filename)

  if cached_editorconfigs[filename] ~= nil then
    return cached_editorconfigs[filename]
  end

  local file = io.open(filename, "r")
  local contents = file:read("*a")
  file:close()

  local editorconfig = parse_editorconfig(contents)
  compile_patterns_in_editorconfig(editorconfig)

  cached_editorconfigs[filename] = editorconfig
  return editorconfig

end


----
-- SEARCH
----


local function parent_directories(filename)

  if PLATFORM == "Windows" then
    -- jank
    filename = filename:gsub('\\', '/')
  end

  local function parent_directory(path)
    -- trim trailing slashes
    path = path:match("^(.-)/*$")
    -- find last slash
    local last_slash_pos = -1
    for i = #path, 1, -1 do
      if path:sub(i, i) == '/' then
        last_slash_pos = i
        break
      end
    end
    -- return nil if this is the root directory
    if last_slash_pos < 0 then
      return nil
    end
    -- trim everything up until the last slash
    return path:sub(1, last_slash_pos - 1)
  end

  return function ()
    filename = parent_directory(filename)
    return filename
  end

end

local function case_insensitive_eq(a, b)
  a = a or ""
  return a:lower() == b
end

local function apply_editorconfig(doc, editorconfig)

  local function setting(name, value, parser)
    if value then
      value = value:lower()
      if value ~= "unset" then
        doc.config[name] = parser(value)
      end
    end
  end

  local function warn(message)
    core.error("editorconfig: " .. message)
  end

  local filename = system.absolute_path(doc.filename)
  for pattern, sec in pairs(editorconfig.sections) do
    local fname = filename
    if not pattern.is_path then
      fname = common.basename(fname)
    end
    if common.match_pattern(fname, pattern) then
      setting("tab_type", sec.indent_style, function (x)
        if     x == "tab"   then return "hard"
        elseif x == "space" then return "soft"
        end
      end)
      setting("indent_size", sec.indent_size, tonumber)
      if sec.end_of_line ~= nil then
        local x = sec.end_of_line
        if     x == "cr"   then warn("end_of_line = cr is not supported")
        elseif x == "lf"   then doc.crlf = false
        elseif x == "crlf" then doc.crlf = true
        end
      end
      -- nonstandard
      setting("line_limit", sec.max_line_length, tonumber)
    end
  end

end

local function find_editorconfigs(doc)

  local filename = doc.filename
  local editorconfigs = {}
  for dir in parent_directories(system.absolute_path(filename)) do
    local editorconfig_filename = dir .. "/.editorconfig"
    if system.get_file_info(editorconfig_filename) then
      local editorconfig = load_editorconfig(editorconfig_filename)
      table.insert(editorconfigs, editorconfig)
      if case_insensitive_eq(editorconfig.preamble.root, "true") then
        break
      end
    end
  end

  -- apply editorconfigs in reverse order (from root to current directory)
  for i = #editorconfigs, 1, -1 do
    local editorconfig = editorconfigs[i]
    apply_editorconfig(doc, editorconfig)
  end

end

local doc_load = Doc.load
function Doc:load(filename)
  doc_load(self, filename)
  find_editorconfigs(self)
end

local doc_save = Doc.save
function Doc:save(filename, abs_filename)
  local filename_changed = self.filename ~= filename
  doc_save(self, filename, abs_filename)
  if filename_changed then
    find_editorconfigs(self)
  end
end

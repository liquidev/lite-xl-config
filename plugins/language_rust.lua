-- lite-xl 1.16

local syntax = require "core.syntax"

syntax.add {
  files = { "%.rs$" },
  comment = "//",
  patterns = {
    { pattern = "//.-\n",                 type = "comment"  },
    { pattern = { "/%*", "%*/" },         type = "comment"  },
    { pattern = { '"', '"', '\\' },       type = "string"   },
    { pattern = { "`", "`", '\\' },       type = "string"   },
    { pattern = "0[bB][01_]+",            type = "number"   },
    { pattern = "0[oO][0-7_]+",           type = "number"   },
    { pattern = "0[xX][0-9a-fA-F_]+",     type = "number"   },
    { pattern = "%d[%d_]*%.[%d_]+[eE][%-%+]?[%d_]+", type = "number"   },
    { pattern = "%d[%d_]*%.[%d_]+",         type = "number"   },
    { pattern = "%d[%d_]*",                 type = "number"   },
    { pattern = "[%+%-=/%*%^%%<>!?~|&]",  type = "operator" },
    { pattern = "%.%.[=%.]?",             type = "operator" },
    { pattern = "b?'.'",                  type = "string" },
    { pattern = "b?'\\.-'",               type = "string" },
    { pattern = "[%a_][%w_]*%f[(]",       type = "function" },
    { pattern = "[%a_][%w_]*!",           type = "function" },
    { pattern = "[A-Z_][A-Z_0-9]+%f[^A-Z_0-9]", type = "symbol" },
    { pattern = "[A-Z][%w_]*",            type = "keyword2" },
    { pattern = "'[%a_][%w_]*",           type = "literal"   },
    { pattern = "[%a_][%w_]*",            type = "symbol"   },
  },
  symbols = {
    ["abstract"]      = "keyword",
    ["as"]            = "keyword",
    ["async"]         = "keyword",
    ["await"]         = "keyword",
    ["become"]        = "keyword",
    ["box"]           = "keyword",
    ["break"]         = "keyword",
    ["const"]         = "keyword",
    ["continue"]      = "keyword",
    ["crate"]         = "keyword",
    ["do"]            = "keyword",
    ["dyn"]           = "keyword",
    ["else"]          = "keyword",
    ["enum"]          = "keyword",
    ["extern"]        = "keyword",
    ["final"]         = "keyword",
    ["fn"]            = "keyword",
    ["for"]           = "keyword",
    ["if"]            = "keyword",
    ["impl"]          = "keyword",
    ["in"]            = "keyword",
    ["let"]           = "keyword",
    ["loop"]          = "keyword",
    ["macro"]         = "keyword",
    ["match"]         = "keyword",
    ["mod"]           = "keyword",
    ["move"]          = "keyword",
    ["mut"]           = "keyword",
    ["override"]      = "keyword",
    ["priv"]          = "keyword",
    ["pub"]           = "keyword",
    ["ref"]           = "keyword",
    ["return"]        = "keyword",
    ["self"]          = "keyword2",
    ["static"]        = "keyword",
    ["struct"]        = "keyword",
    ["super"]         = "keyword",
    ["trait"]         = "keyword",
    ["try"]           = "keyword",
    ["type"]          = "keyword",
    ["typeof"]        = "keyword",
    ["union"]         = "keyword",
    ["unsafe"]        = "keyword",
    ["unsized"]       = "keyword",
    ["use"]           = "keyword",
    ["virtual"]       = "keyword",
    ["where"]         = "keyword",
    ["while"]         = "keyword",
    ["yield"]         = "keyword",
    ["i32"]           = "keyword2",
    ["i64"]           = "keyword2",
    ["i128"]          = "keyword2",
    ["i16"]           = "keyword2",
    ["i8"]            = "keyword2",
    ["u8"]            = "keyword2",
    ["u16"]           = "keyword2",
    ["u32"]           = "keyword2",
    ["u64"]           = "keyword2",
    ["usize"]         = "keyword2",
    ["isize"]         = "keyword2",
    ["f32"]           = "keyword2",
    ["f64"]           = "keyword2",
    ["f128"]          = "keyword2",
    ["str"]           = "keyword2",
    ["bool"]          = "keyword2",
    ["char"]          = "keyword2",
    ["true"]          = "literal",
    ["false"]         = "literal",
  },
}


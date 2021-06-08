-- lite-xl 1.16

local syntax = require "core.syntax"

syntax.add {
  files = "%.cfl$",
  comment = "--",
  patterns = {
    { pattern = "%-%-.-\n",            type = "comment"  },
    { pattern = "%d+[%d%.eE]*",        type = "number"   },
    { pattern = "%.?%d+",              type = "number"   },
    { pattern = "[+%-*/<>=~!?]",       type = "operator" },
    { pattern = "[|:]",                type = "keyword" },
    { pattern = "[%a_][%w_]*%s*%f[:]", type = "function" },
    { pattern = "[%a_][%w_]*",         type = "symbol"   },
  },
  symbols = {
    ["and"] = "keyword",
    ["or"]  = "keyword",
  },
}


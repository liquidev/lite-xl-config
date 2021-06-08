-- lite-xl 1.16

local syntax = require "core.syntax"

syntax.add {
  files = "%.tsu$",
  comment = "#",
  patterns = {
    { pattern = "#.*\n",                        type = "comment"   },
    { pattern = { '"', '"', '\\' },             type = "string"    },
    { pattern = "%d+%.%d+",                     type = "literal"   },
    { pattern = "%d+",                          type = "literal"   },
    { pattern = "proc%s+%f[(]",                 type = "keyword"   },
    { pattern = "do%s+%f[(]",                   type = "keyword"   },
    { pattern = "[%a_][%w_]*%s*%f[(]",          type = "function"  },
    { pattern = "[%a_][%w_]*%s*%f[{]",          type = "keyword2"  },
    { pattern = "[%a_][%w_]*",                  type = "symbol"    },
    { pattern = "%.%f[^.]",                     type = "normal"    },
    { pattern = "[=+%-*/<>@$~&%%|!?%^&.:\\]+",  type = "operator"  },
  },
  symbols = {
    ["var"]      = "keyword",
    ["block"]    = "keyword",
    ["if"]       = "keyword",
    ["elif"]     = "keyword",
    ["else"]     = "keyword",
    ["while"]    = "keyword",
    ["for"]      = "keyword",
    ["in"]       = "keyword",
    ["continue"] = "keyword",
    ["break"]    = "keyword",
    ["proc"]     = "keyword",
    ["return"]   = "keyword",
    ["do"]       = "keyword",
    ["end"]      = "keyword",
    ["object"]   = "keyword",
    ["impl"]     = "keyword",
    ["import"]   = "keyword",

    ["not"]      = "keyword",
    ["and"]      = "keyword",
    ["or"]       = "keyword",
    ["mod"]      = "keyword",
    ["div"]      = "keyword",
    ["of"]       = "keyword",

    ["nil"]      = "literal",
    ["true"]     = "literal",
    ["false"]    = "literal",
  },
}


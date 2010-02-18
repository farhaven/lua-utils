require("strict")

local ipairs = ipairs
local pairs = pairs
local type = type
local unpack = unpack
local tostring = tostring

local io = io
local string = string
local table = table

module("dbg")

function stderr(...)
    for k, v in ipairs(arg) do
        if type(v) ~= "string" or type(v) ~= "number" then
            arg[k] = tostring(v)
        end
    end
    io.stderr:write(string.format(unpack(arg)))
    io.stderr:flush()
end

function keys(t)
    local k = { }
    for key, _ in pairs(t) do
        table.insert(k, key)
    end
    table.sort(k)
    return k
end

function dump(t, d, deep)
    deep = (deep ~= nil) or true
    if type(t) ~= "table" then
        stderr("(%s) %s\n", type(t), t)
        return
    end

    d = d or 0
    local p = string.rep(" ", d)
    if d == 0 then
        stderr("\n")
    end
    local k = keys(t)
    for _, k in ipairs(k) do
        local v = t[k]
        if type(v) == "table" then
            stderr("%s%s (table)\n", p, k)
            if deep then
                dump(v, d + 1, true)
            end
        else
            stderr("%s%s (%s) \"%s\"\n", p, k, type(v), v)
        end
    end
end

stderr("debug module included\n")

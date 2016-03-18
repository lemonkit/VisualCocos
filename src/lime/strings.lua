local module = {}

module.split = function(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end

function module.hasprefix(s,prefix)
    return s:sub(1,#prefix) == prefix
end

return module

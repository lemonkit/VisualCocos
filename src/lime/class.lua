local throw = require "lime.throw"

local module = {}

function module.typeof(obj)
    local objtype = type(obj)
    if objtype == "table" and obj.__cname then
        return obj.__cname
    end

    return objtype
end

function module.classbyname (name)
    local nodes = {}

    for nodename in name:gmatch("[^%.]+") do
        table.insert(nodes,nodename)
    end

    local node = cc.exports

    for i = 1,#nodes do
        node = node[nodes[i]]
        if not node then
            return false
        end
    end

    return true,node
end

function module.def(name,metaclass)
    printInfo("register class type(%s)",name)
    local nodes = {}

    for nodename in name:gmatch("[^%.]+") do
        table.insert(nodes,nodename)
    end

    local node = cc.exports

    for i = 1,#nodes - 1 do
        if not node[nodes[i]] then
            node[nodes[i]] = {}
        end
        node = node[nodes[i]]
    end

    local creator = node[nodes[#nodes]]

    if creator then
        throw("duplicate class(%s) defined",name)
    end

    creator = {}
    node[nodes[#nodes]] = creator

    creator.__cname   = name
    creator.__metatable = {}

    for k,v in pairs(metaclass) do
        creator.__metatable[k] = v
    end

    creator.__super = metaclass.super
    creator.__ctor = metaclass.ctor
    creator.__properties = metaclass.properties or {}
    creator.__final = metaclass.final
    creator.__metatable.properties = nil
    creator.__metatable.super = nil
    creator.__metatable.final = nil
    creator.__metatable.ctor = nil

    creator.create = function(_,properties)
        printInfo("create type(%s) obj",name)

        local obj = nil
        if creator.__super then
            local createType = type(creator.__super)
            if createType == "table" then
                obj = creator.__super.create(properties)
            elseif createType == "function" then
                obj = creator.__super(properties)
            else
                throw("%s unsupport super type(%s)",name,createType)
            end

            local metatable = getmetatable(obj)

            local index = {}

            for k,v in pairs(metatable.__index) do
                index[k] = v
            end

            for k,v in pairs(creator.__metatable) do
                index[k] = v
            end

            metatable.__index = index
        else
            obj = { }
            setmetatable(obj,{
                 __index = creator.__metatable;
                 __gc    = creator.__final;
            })
        end

        for name,val in pairs(properties or {}) do
            local target = creator.__properties[name]

            if target and type(target) == type(val) then
                if type(target) ~= "table" or  target.__cname == val.__cname  then
                    printInfo("set object(%p) property(%s:%s)",obj,name,typeof(val))
                    obj[name] =val
                else
                    printInfo("ignore object(%p) property(%s:%s:%s)",obj,name,typeof(val),typeof(target))
                end
            else
                printInfo("%s ignore object(%p) property(%s:%s:%s)",creator.__cname, obj,name,typeof(val),typeof(target))
            end
        end

        obj.__cname = creator.__cname

        if creator.__ctor then
            creator.__ctor(obj)
        end

        printInfo("create type(%s) obj -- success",name)

        return obj
    end

    printInfo("register class type(%s) -- success",name)
end

return module

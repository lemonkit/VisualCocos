local strings = require "lime.strings"
local fs      = cc.FileUtils:getInstance()


local loadfromfile = function (path)
    local block,err = loadfile(path,"bt")

    if err then
        throw("load data file error :%s",path)
    end

    return block()
end

local module = {
    properties = {
        path = "";
    };
}

function module:ctor()
    self.data    = loadfromfile(self.path)
    self.objects = {}
end

function module:loadobject(idx,config)

    if type(config) ~= "table" then
        return config
    end

    -- this is a type object
    if config.__type__ then
        local typename = config.__type__

        local ok, creator = classbyname(typename)

        if not ok then
            throw("unregister type :%s",typename)
        end

        local params = {}

        for name,val in pairs(config) do
            if not strings.hasprefix(name,"_") then
                params[name] = self:loadobject(idx,val)
            end
        end

        if "lime.SceneAsset" == typename then
            printInfo("lime.SceneAsset %s",params.scene)
        end
        -- create new object
        local obj = creator:create(params)

        self.objects[idx] = obj

        -- invoke the setmethod
        for name,val in pairs(config) do
            local methodName = name:gsub("^_([^_])(.*)$",function (header,tail)
                return "set" .. string.upper(header) .. tail
            end)

            if methodName ~= name then
                local method = obj[methodName]
                if method and type(method) == "function" then
                    val = self:loadobject(idx,val)
                    printInfo("[%p:%d]invoke type(%s) method(%s) with arg(%s)",obj,idx,config.__type__,methodName,val)
                    method(obj,val)
                else
                    if type(obj.__index) == "function" then
                        method = obj:__index(methodName)
                        if method and type(method) == "function" then
                            val = self:loadobject(idx,val)
                            printInfo("[%p:%d]invoke type(%s) method(%s) with arg(%s)",obj,idx,config.__type__,methodName,val)
                            method(obj,val)
                        end
                    else
                        printInfo("ignore unknown type(%s) property(%s)",config.__type__,name)
                    end
                end
            end
        end

        return obj
    elseif config.__id__ then

        local obj = self.objects[config.__id__]

        if obj then
            return obj
        end

        obj = self:loadobject(config.__id__,self.data[config.__id__])

        return obj
    end

    local array = {}

    for _,child in ipairs(config) do
        table.insert(array,self:loadobject(config.__id__,child))
    end


    return array
end

function module:load()
    for idx,config in ipairs(self.data) do
        if self.objects[idx]  == nil then
            self.objects[idx] = self:loadobject(idx,config)
        end
    end

    local root = self.objects[1]

    if root then
        root:load()
    end
end

def("lime.loader",module)

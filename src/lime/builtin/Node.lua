local module = {}

module.super =  function ()
    return app.odb:createobj()
end

function module:ctor()
    self.ccnode = cc.Node:create()
end

function module:__index(name)
    local metatable = getmetatable(self.ccnode)

    local method = metatable.__index(self.ccnode,name)

    if not method then return nil end

    return function(sprite,...)
        method(self.ccnode,...)
    end
end

function module:load()
    for _,child in ipairs(self.children) do
        child:load()
    end

    for _,com in ipairs(self.components or {}) do
        com:onload()
    end

    if self.parent then
        print(self.__cname,self.parent)
        self.parent.ccnode:addChild(self.ccnode)
    end
end

def("lime.Node",module)

local module = {}

module.properties = {
    node = lime.Node;
}

module.super = lime.component

function module:ctor()
    self.ccnode = cc.Sprite:create()
end

function module:__index(name)
    local metatable = getmetatable(self.ccnode)

    local method = metatable.__index(self.ccnode,name)

    if not method then return nil end

    return function(sprite,...)
        method(self.ccnode,...)
    end
end


function module:onload()
    self.target.ccnode:addChild(self.ccnode)
end

function module:update(delta)
    print(delta)
end

function module:onclosed()
end


def("lime.Sprite",module)

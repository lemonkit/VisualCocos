local module = {
    properties = {
        id = 0; -- the entity id
    }
}

function module:ctor ()
    self.children = {}
end

function module:setComponent()
end

function module:setParent (parent)
    self.parent = parent
end

function module:setChildren(children)
    self.children = children

    for _,child in ipairs(children) do
        child:setParent(self)
    end
end

function module:setComponents(components)
    self.components = components



    for _,com in ipairs(components) do

        com:setTarget(self)
    end
end

function module:load()
    for _,child in ipairs(self.children) do
        child:load()
    end

    for _,com in ipairs(self.components or {}) do
        print("===========")
        com:onload()
    end
end

def("lime.entity",module)

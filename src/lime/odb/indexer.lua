require "lime.odb.table"

local module = {}

module.properties = {
    name        = "";
    a       = lime.table;
}

function module:ctor ()
    self.components = {}
end

function module:insert (com)
    self.components[com.target] = com
end

function module:update (delta)
    for _,com in pairs(self.components) do
        com:update(delta)
    end
end


def("lime.odbindexer",module)

local throw = require "lime.throw"

local module = {
    properties = {
        name = "";
    }
}

function module:ctor()
    self.components = {}
    self.asdb = lime.asdb:create()
    self.odb = lime.odb:create({ name = self.name })
end

function module:run(name)
    -- get runing prefab
    local ok,datafile = self.asdb:search(name)

    if not ok then
        throw("asset not found :%s",name)
    end

    local loader = lime.loader:create({ path = datafile })
    -- load scene from data file
    loader:load()

    local assert = loader.objects[1]

    display.runScene(assert.scene.ccnode)
end

def("lime.app",module)

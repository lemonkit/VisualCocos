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
    if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end
end

function module:run(name)
    -- get runing prefab
    local ok,datafile = self.asdb:search(name)

    if not ok then
        throw("asset not found :%s",name)
    end

    local loader = lime.loader:create({ path = datafile })
    -- load scene from data file
    local ok,obj = loader:load()

    assert(ok and obj.__cname == "lime.SceneAsset","load prefab must be a scene")

    local table = self.odb:createtable("lime")

    table:insert(obj.scene)

    display.runScene(obj.scene.ccnode)

    local scheduler = cc.Director:getInstance():getScheduler()

    scheduler:scheduleScriptFunc(function(delta)
        table:update(delta)
    end,0,false)
end

def("lime.app",module)

local module = {}

module.properties = {
    name = ""; -- scene name
}

module.super = function ()
    return app.odb:createobj()
end

function module:ctor ()
    printInfo("scene: %p",self.setChildren)
    self.ccnode = display:newScene(self.name)
end

def("lime.Scene",module)

-- return function(app,params)
--     local ccnode = display.newScene(params.name)
--     return require("lime.builtin.Node")(app,{
--         ccnode = ccnode
--     })
-- end

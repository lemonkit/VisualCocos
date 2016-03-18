local module = {}

module.properties = {
    scene = lime.Scene;
}

function module:load()
    self.scene:load()
end

def("lime.SceneAsset",module)

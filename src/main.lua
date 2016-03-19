
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")

require "config"
require "cocos.init"
require "lime.init"

local function main()

    cc.exports.app = lime.app:create({
        name = CC_APP_NAME
    })
    app:run("asdb://prefab/test.fire")
end

local status, msg = pcall(main)
if not status then
    print(msg)
end

name "github.com/lemonkit/VisualCocos"

task.run = function(self)
    local filepath  = require "lemoon.filepath"
    local sys        = require "lemoon.sys"
    local path      = self.Owner.Path
    local target    = self.Owner.Loader.Config.TargetHost
    local platform  = "win32"

    local exepath   = filepath.join(path,"simulator",platform,"VisualCocos" .. sys.EXE_NAME)

    local exec = sys.exec(exepath,function(msg)
        print(msg)
    end)
    exec:dir(path)

    exec:run("-workdir",path)
end

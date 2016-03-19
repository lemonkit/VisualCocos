local module = {}

module.properties = {
    priority = 1; -- component system execute priority
}

function module:setTarget(target)
    self.target = target
end

function module:setPriority(priority)
    self.priority = priority
end


function module:update(delta)
end

def("lime.component",module)

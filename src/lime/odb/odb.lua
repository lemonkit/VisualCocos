-- the runtime gamee object database module
local module = {
    properties = {
        name        = "odb";
    }
}

-- create new odb object with tag name
function module:ctor()
    self.tables = {}
    self.com = {}
    self.entities = {}
    self.idgen = 0
end

-- create new table with tag name, if the table already exists return it
function module:createtable (name)
    local table = self.tables[name]

    if table == nil then
        table = lime.odbtable:create({ name = name,odb = self })
    end

    return table
end

-- create new game entity object
function module:createobj()
    local id = 0
    while true do
        if not self.entities[self.idgen] then
            id = self.idgen
            break
        end

        self.idgen = self.idgen + 1
    end

    local obj = lime.entity:create( { id = id })

    self.entities[id] = obj

    return obj
end

function module:removeobj (obj)
    self.entities[obj.id] = nil
end

def("lime.odb",module)

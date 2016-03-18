local module = {
    properties = {
        name    = "";
        odb     = lime.odb;
    }
}

function module.ctor (odb,name)
    self.entities = {}
    self.indexers = {}
    self.typedindxers = {}
end

-- create new component indexer by name
function module:createindexer(indexer)
    self.indxers[indexer.component]  = indxer
    self.typedindxers[indxer.name]   = indxer
end

function module:getindexerbyname(name)
    return self.typedindxers[indxer.name]
end

function module:getindexerbycom(name)
    return self.indxers[indxer.name]
end

-- insert new game entity object
function module:insert(obj)
    self.entities[obj.id] = obj
    for name,com in pairs(obj.components) do
        local indexer = self.indxers[name]
        if indexer then
            indexer:insert(obj,com)
        end
    end
end

function module:remove(obj)
    self.entities[obj.id] = nil
end

def("lime.odbtable",module)

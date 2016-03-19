local module = {
    properties = {
        name    = "";
        odb     = lime.odb;
    }
}

function module:ctor (odb,name)
    self.entities = {}
    self.indexers = {}
    self.typedindexers = {}
end

-- -- create new component indexer by name
-- function module:createindexer(indexer)
--     self.indxers[indexer.component]  = indxer
--     self.typedindxers[indxer.name]   = indxer
-- end
--
-- function module:getindexerbyname(name)
--     return self.typedindxers[indxer.name]
-- end
--
-- function module:getindexerbycom(name)
--     return self.indxers[indxer.name]
-- end

-- insert new game entity object
function module:insert(obj)
    self.entities[obj.id] = obj
    for _,com in ipairs(obj.components or {}) do
        local indexer = self.typedindexers[com.__cname]
        if not indexer then
            indexer = lime.odbindexer:create({ name = com.__cname, table = self})
            self.typedindexers[com.__cname] = indexer
            table.insert(self.indexers,com.priority,indexer)
        end

        indexer:insert(com)
    end

    for _,child in ipairs(obj.children) do
        self:insert(child)
    end
end

function module:update(delta)
    for _,indexer in ipairs(self.indexers) do
        indexer:update(delta)
    end
end

function module:remove(obj)
    self.entities[obj.id] = nil
end

def("lime.odbtable",module)

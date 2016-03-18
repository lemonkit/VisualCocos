local fs     = cc.FileUtils:getInstance()
-- the assets database interface
local module = {}

local urlregex = "^(asdb://)([^:]+)$"

-- search asset resource by asdb url
-- @return the asset resource's fullpath
function module:search(url)
    local path = url:gsub(urlregex,"%2")

    if path == url then
        throw("invalid asdb url :%s",url)
    end

    if not fs:isFileExist(path) then

        return false
    end
    -- return fullpath
    return true,fs:fullPathForFilename(path)
end

def("lime.asdb",module)

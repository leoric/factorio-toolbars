import("Thing")
import("factorio.ItemFluidPrototypes")

---@class Item : Thing
Item = Thing:extendAs("Item")

---@public
---@param name string
---@param quality string optional
---@return Item
function Item.new(name, quality)
    local this = Item:super(Thing.new(name))
    this._quality = quality and quality or "normal"
    return this
end

function Item:id()
    return self:name() .. "_" .. self:quality()
end

---@public
---@return string
function Item:quality()
    return self._quality
end

---@public
---@return Item
function Item:increaseQuality()
    local next = prototypes.quality[self:quality()].next
    if next then
        return Item.new(self:name(), next.name)
    else
        return self
    end
end

---@public
---@return Item
function Item:decreaseQuality()
    local previous
    for _, quality in pairs(prototypes.quality) do
        if quality.next and quality.next.name == self:quality() then
            previous = quality
        end
    end
    if previous then
        return Item.new(self:name(), previous.name)
    else
        return self
    end
end

---@public
---@return ItemIDAndQualityIDPair
function Item:nameQualityPair()
    return { name = self:name(), quality = self:quality() }
end

---[STATIC]
---@public
---@param data table untrusted data, e.g. decoded from clipboard JSON
---@return Item|nil
function Item.fromData(data)
    if type(data) ~= "table" or type(data.name) ~= "string" then
        return nil
    end
    if ItemFluidPrototypes.instance():findItemFluidPrototype(data.name) == nil then
        return nil
    end
    local quality = type(data.quality) == "string" and data.quality or "normal"
    if prototypes.quality[quality] == nil then
        quality = "normal"
    end
    return Item.new(data.name, quality)
end

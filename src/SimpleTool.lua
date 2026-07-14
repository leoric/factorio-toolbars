import("Thing")

---@class SimpleTool : Thing
SimpleTool = Thing:extendAs("SimpleTool")

---@public
---@param name string
---@return SimpleTool
function SimpleTool.new(name)
    return SimpleTool:super(Thing.new(name))
end

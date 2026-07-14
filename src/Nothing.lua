import("Thing")

---@class Nothing : Thing
Nothing = Thing:extendAs("Nothing")

---@public
---@return Nothing
function Nothing.new()
    return Nothing:super(Thing.new("nothing"))
end

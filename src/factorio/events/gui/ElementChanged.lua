import("factorio.events.gui.ChangedEvent")

---@class ElementChanged : ChangedEvent
ElementChanged = ChangedEvent:extendAs("factorio.events.gui.ElementChanged")

---@public
---@param eventData EventData
---@return ElementChanged
function ElementChanged.new(eventData)
    return ElementChanged:super(ChangedEvent.new(eventData))
end

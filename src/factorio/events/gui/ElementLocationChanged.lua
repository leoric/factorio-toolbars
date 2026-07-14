import("factorio.events.gui.ChangedEvent")

---@class ElementLocationChanged : ChangedEvent
ElementLocationChanged = ChangedEvent:extendAs("factorio.events.gui.ElementLocationChanged")

---@public
---@param eventData EventData
---@return ElementLocationChanged
function ElementLocationChanged.new(eventData)
    return ElementLocationChanged:super(ChangedEvent.new(eventData))
end

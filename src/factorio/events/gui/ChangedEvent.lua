import("gui.GuiEvent")

---@class ChangedEvent : GuiEvent
ChangedEvent = GuiEvent:extendAs("factorio.events.gui.ChangedEvent")

---@public
---@param eventData EventData
---@return ChangedEvent
function ChangedEvent.new(eventData)
    return ChangedEvent:super(GuiEvent.new(eventData))
end

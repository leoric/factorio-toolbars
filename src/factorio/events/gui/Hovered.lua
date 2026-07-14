import("gui.GuiEvent")

---@class Hovered : GuiEvent
Hovered = GuiEvent:extendAs("factorio.events.gui.Hovered")

---@public
---@param eventData EventData
---@return Hovered
function Hovered.new(eventData)
    return Hovered:super(GuiEvent.new(eventData))
end

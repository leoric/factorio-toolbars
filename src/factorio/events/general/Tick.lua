import("Event")

---@class Tick : Event
Tick = Event:extendAs("factorio.events.general.Tick")

---@public
---@param tick number
---@return Tick
function Tick.new(tick)
    return Tick:super(Event.new(tick))
end

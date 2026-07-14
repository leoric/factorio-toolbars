import("Event")

---@class Picked : Event
Picked = Event:extendAs("player.events.Picked")

---@public
---@param thing Thing
---@return Picked
function Picked.new(thing)
    return Picked:super(Event.new(thing:id()))
end

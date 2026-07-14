import("Event")

---@class Released : Event
Released = Event:extendAs("player.events.Released")

---@public
---@param thing Thing
---@return Released
function Released.new(thing)
    return Released:super(Event.new(thing:id()))
end

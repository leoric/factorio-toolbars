import("Event")

---@class PlayerSettingChanged : Event
PlayerSettingChanged = Event:extendAs("factorio.events.settings.PlayerSettingChanged")

---@public
---@param settingName string
---@return PlayerSettingChanged
function PlayerSettingChanged.new(settingName)
    return PlayerSettingChanged:super(Event.new(settingName))
end

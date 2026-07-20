import("player.inventory.personal.MainInventory")

---@class GodMainInventory : MainInventory
GodMainInventory = MainInventory:extendAs("player.inventory.personal.editor.GodMainInventory")

---@public
---@param player Player
---@return GodMainInventory
function GodMainInventory.new(player)
    return GodMainInventory:super(MainInventory.new(player))
end

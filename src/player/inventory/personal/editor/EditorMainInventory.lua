import("player.inventory.personal.MainInventory")

---@class EditorMainInventory : MainInventory
EditorMainInventory = MainInventory:extendAs("player.inventory.personal.editor.EditorMainInventory")

---@public
---@param player Player
---@return EditorMainInventory
function EditorMainInventory.new(player)
    return EditorMainInventory:super(MainInventory.new(player))
end

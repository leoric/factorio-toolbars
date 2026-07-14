import("player.inventory.personal.MainInventory")
import("player.inventory.personal.character.crafting.CraftingInventoryChanged")
import("player.inventory.personal.character.crafting.CraftingPlan")

---@class CharacterMainInventory : MainInventory
---@field private _player Player
---@field private _craftingCategories table<string, boolean>
CharacterMainInventory = MainInventory:extendAs("player.inventory.personal.character.CharacterMainInventory")

---@public
---@param player Player
---@return CharacterMainInventory
function CharacterMainInventory.new(player)
    local this = CharacterMainInventory:super(MainInventory.new(player))
    this._player = player
    this._craftingCategories = this:freshCharacterCraftingCategories()
    return this
end

---@private
---@return table<string, boolean>
function CharacterMainInventory:freshCharacterCraftingCategories()
    local craftingCategories = {}
    for category, boolean in pairs(self._player:luaPlayer().character.prototype.crafting_categories) do
        craftingCategories[category] = true
    end
    return craftingCategories
end

---@param recipe LuaRecipe
---@param requestedCraftCount number
function CharacterMainInventory:craft(recipe, requestedCraftCount)
    return self._player:luaPlayer().begin_crafting { recipe = recipe, count = requestedCraftCount }
end

---@private
---@param itemName string
---@return CraftingPlan[]
function CharacterMainInventory:craftingPlansInDescendingCountOrderForAnItem(itemName)
    local recipes = self._player:recipes():findRecipesByItemProductName(itemName)

    ---@type CraftingPlan[]
    local plans = {}
    for i, recipe in ipairs(recipes) do
        table.insert(plans, CraftingPlan.new(itemName, recipe, self))
    end
    table.sort(plans, function(first, second)
        return first:compareTo(second)
    end)
    return plans
end

--- Used by CraftingPlan
---@public
---@param recipe LuaRecipe
---@return boolean
function CharacterMainInventory:canCraft(recipe)
    for i, recipeCategory in ipairs(recipe.categories) do
        if self._craftingCategories[recipeCategory] then
            return true
        end
    end
    return false;
end

--- Used by CraftingPlan
---@public
---@param recipeName string
---@return number
function CharacterMainInventory:recipeCraftableCount(recipeName)
    return self._player:luaPlayer().get_craftable_count(recipeName)
end

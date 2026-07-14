import("player.inventory.personal.MainInventory")
import("player.inventory.personal.character.crafting.CraftingInventoryChanged")
import("player.inventory.personal.character.crafting.CraftingPlan")

---@class CharacterMainInventory : MainInventory
---@field private _player Player
---@field private _craftingCategories string[]
CharacterMainInventory = MainInventory:extendAs("player.inventory.personal.character.CharacterMainInventory")

---@public
---@return CharacterMainInventory
---@param player Player
function CharacterMainInventory.new(player)
    local this = CharacterMainInventory:super(MainInventory.new(player))
    this._player = player
    this._craftingCategories = this:freshCharacterCraftingCategories()
    return this
end

---@private
function CharacterMainInventory:freshCharacterCraftingCategories()
    local craftingCategories = {}
    for categoryName, _ in pairs(self._player:luaPlayer().character.prototype.crafting_categories) do
        table.insert(craftingCategories, categoryName)
    end
    return craftingCategories
end

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
    table.sort(plans, function(first, second) return first:compareTo(second) end)
    return plans
end

--- Used by CraftingPlan
---@public
---@param recipe LuaRecipe
---@return boolean
function CharacterMainInventory:canCraft(recipe)
    for i, category in ipairs(self._craftingCategories) do
        for i, recipeCategory in ipairs(recipe.categories) do
            if category == recipeCategory then
                return true
            end
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

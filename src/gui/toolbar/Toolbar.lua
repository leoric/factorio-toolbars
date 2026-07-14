import("factorio.events.controls.ToggleToolbarHeader")
import("gui.Box")
import("gui.Window")
import("gui.toolbar.Strut")
import("gui.toolbar.header.ToolbarHeader")
import("gui.toolbar.header.OneSectionMode")
import("gui.toolbar.content.ToolbarContent")
import("gui.toolbar.content.sections.Sections")
import("gui.toolbar.content.sections.section.Section")
import("gui.toolbar.content.sections.section.content.table.Table")
import("gui.toolbar.content.sections.section.content.table.slots.empty.EmptySlot")
import("gui.toolbar.content.sections.section.content.table.slots.item.ItemSlot")
import("Item")
import("player.events.ToolbarsToggled")

---@class Toolbar : Window
---@field private _lastOccupiedColumnIndex number
Toolbar = Window:extendAs("gui.toolbar.Toolbar")

---@public
---@param parent Component
---@return Toolbar
function Toolbar.create(parent)
    return Window.create(
            Toolbar,
            parent,
            "toolbar",
            function(instance)
                ToolbarHeader.create(instance)
                ToolbarContent.create(instance)
                Strut.create(instance)
                instance:adjustGrids()
            end
    )
end

---@protected
---@param element LuaGuiElement
---@return Toolbar
function Toolbar.new(element)
    return Toolbar:super(Window.new(element, { ToolbarHeader, ToolbarContent, Strut }, Toolbars.styles.toolbar.box))
end

function Toolbar:initialize()
    self:setControls({ [ToggleToolbarHeader] = function() self:header():toggle() end })
    self:player():eventBus():subscribeTo(ToolbarsToggled, self, function(event) self:refresh(event) end)

    self._lastOccupiedColumnIndex = self:lastOccupiedColumnIndex()
    self:freezeWidth()
end

---@public
function Toolbar:toggle()
    if self:content():isVisible() then
        self:collapse()
    else
        self:expand()
    end
end

---@public
function Toolbar:collapse()
    local collapseToolbar = self:header():child(CollapseToolbar)
    if collapseToolbar then
        collapseToolbar:collapsed()
    end
    self:content():hide()
end

---@public
function Toolbar:expand()
    local expandToolbar = self:header():child(ExpandToolbar)
    if expandToolbar then
        expandToolbar:expanded()
    end
    self:content():show()
end

---@public
---@param sectionToExclude Section
function Toolbar:collapseAllSectionsExcluding(sectionToExclude)
    for _, section in ipairs(self:content():sections():sections()) do
        if section ~= sectionToExclude then
            section:collapse()
        end
    end
end

---@public
function Toolbar:collapseAllSections()
    for _, section in ipairs(self:content():sections():sections()) do
        section:collapse()
    end
end

---@public
function Toolbar:addSection()
    if self:header():child(OneSectionMode):toggled() then
        self:collapseAllSections()
    end
    if self:isAlignedTop() then
        self:content():sections():addSectionOntoEnd()
    else
        self:content():sections():addSectionOntoStart()
    end
    self:adjustGrids()
end

---@public
---@return number
function Toolbar:sectionsCount()
    return self:content():sections():count()
end

---@public
function Toolbar:tableChanged()
    self._lastOccupiedColumnIndex = self:lastOccupiedColumnIndex()
    self:adjustGrids()
    self:freezeWidth()
end

---@public
function Toolbar:adjustGrids()
    if not self:isLocked() then
        for _, table in ipairs(self:tables()) do
            table:adjustUnlocked()
        end
    end
end

function Toolbar:lock()
    Toolbar:super().lock(self)
    self:freezeWidth()
end

function Toolbar:unlock()
    Toolbar:super().unlock(self)
    self:freezeWidth()
end

---@private
function Toolbar:freezeWidth()
    --migration to 2.13.0
    if not self:strut() then
        Strut.create(self)
    end

    self:strut():setFixedWidth(self:content():width())

    --migration to 2.13.0
    self:element().style.minimal_width = 0
    --migration to 2.8.1
    if self:header() then
        self:header():element().style.minimal_width = 0
    end
end

function Toolbar:extraSpacing()
    return (self:header() and self:header():isVisible() and self:content() and self:content():isVisible()) and self:scale(Toolbars.styles.toolbar.spacing) or 0
end

---@private
function Toolbar:refresh()
    if self:isOn() then
        self:show()
    else
        self:hide()
    end
end

function Toolbar:show()
    if self:isOn() then
        Toolbar:super().show(self)
    end
end

---@private
---@return boolean
function Toolbar:isOn()
    return self:player():toolbarsAreOn()
end

---@private
---@return boolean
function Toolbar:isLocked()
    return self:child(ToolbarHeader):isLocked()
end

---@public
---@return number
function Toolbar:lastOccupiedColumnIndex()
    local lastOccupiedColumnIndex = 0
    for _, table in ipairs(self:tables()) do
        lastOccupiedColumnIndex = math.max(lastOccupiedColumnIndex, table:lastOccupiedColumnIndex())
    end
    return lastOccupiedColumnIndex
end

---@public
function Toolbar:alignTop()
    if not self:isAlignedTop() then
        self:header():swapWith(self:content())
        self:keepWithinTheScreen()
        Toolbar:super().alignTop(self)
    end
end

---@public
---@return boolean
function Toolbar:isAlignedTop()
    return not self:isAlignedBottom()
end

---@public
function Toolbar:alignBottom()
    if not self:isAlignedBottom() then
        self:header():swapWith(self:content())
        self:keepWithinTheScreen()
        Toolbar:super().alignBottom(self)
    end
end

---@public
---@return boolean
function Toolbar:isAlignedBottom()
    return self:header() and self:header():element().get_index_in_parent() ~= 1
end

---@public
---@return ToolbarHeader
function Toolbar:header()
    return self:child(ToolbarHeader)
end

---@private
---@return ToolbarContent
function Toolbar:content()
    return self:child(ToolbarContent)
end

---@private
---@return Table[]
function Toolbar:tables()
    local tables = {}
    for _, section in pairs(self:content():sections():sections()) do
        table.insert(tables, section:content():table())
    end
    return tables
end

---@public
---@return string
function Toolbar:exportItemsJson()
    return helpers.table_to_json({ items = self:exportedItems() })
end

---@public
---@param jsonText string
function Toolbar:importItemsFromJson(jsonText)
    local success, decoded = pcall(helpers.json_to_table, jsonText)
    if not success or type(decoded) ~= "table" or type(decoded.items) ~= "table" then
        return
    end
    self:importItems(decoded.items)
end

---@private
---@return ItemIDAndQualityIDPair[]
function Toolbar:exportedItems()
    local items = {}
    for _, toolbarTable in ipairs(self:tables()) do
        for _, slot in ipairs(toolbarTable:slots()) do
            if slot:isInstanceOf(ItemSlot) then
                table.insert(items, slot:item():nameQualityPair())
            end
        end
    end
    return items
end

---@private
---@param items table
function Toolbar:importItems(items)
    local emptySlots = self:emptySlots()
    local slotIndex = 1
    for _, itemData in ipairs(items) do
        if slotIndex > #emptySlots then
            break
        end
        local item = Item.fromData(itemData)
        if item then
            emptySlots[slotIndex]:fillWithItem(item)
            slotIndex = slotIndex + 1
        end
    end
end

---@private
---@return EmptySlot[]
function Toolbar:emptySlots()
    local emptySlots = {}
    for _, toolbarTable in ipairs(self:tables()) do
        for _, slot in ipairs(toolbarTable:slots()) do
            if slot:isInstanceOf(EmptySlot) then
                table.insert(emptySlots, slot)
            end
        end
    end
    return emptySlots
end

---@public
---@return table
function Toolbar:exportState()
    local sections = {}
    for _, section in ipairs(self:content():sections():sections()) do
        table.insert(sections, section:exportState())
    end
    return {
        x = self:element().location.x,
        y = self:element().location.y,
        locked = self:isLocked(),
        alignedTop = self:isAlignedTop(),
        oneSectionMode = self:header():child(OneSectionMode):toggled(),
        headerVisible = self:header():isVisible(),
        sections = sections
    }
end

---@public
---@param state table
function Toolbar:applyState(state)
    if type(state) ~= "table" then
        return
    end

    local sections = type(state.sections) == "table" and state.sections or {}
    for _ = 2, #sections do
        self:addSection()
    end

    local sectionComponents = self:content():sections():sections()
    for i, sectionState in ipairs(sections) do
        if sectionComponents[i] then
            sectionComponents[i]:applyState(sectionState)
        end
    end
    self:tableChanged()

    if state.alignedTop == false then
        self:alignBottom()
    end

    if type(state.oneSectionMode) == "boolean" then
        self:header():child(OneSectionMode):setToggled(state.oneSectionMode)
    end

    if state.headerVisible == false then
        self:header():hide()
    end

    if type(state.x) == "number" and type(state.y) == "number" then
        self:setLocation({ x = state.x, y = state.y })
    end

    if state.locked then
        self:lock()
    end
end

---@private
---@return Strut
function Toolbar:strut()
    return self:child(Strut)
end

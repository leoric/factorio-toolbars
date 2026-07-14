import("gui.Leaf")
import("gui.Box")
import("gui.toolbar.Toolbar")
import("gui.toolbar.header.ToolbarHeader")

---@class ToolbarHeaderButton : Leaf
---@field private __lockedBox Box
---@field private __unlockedBox Box
---@field private _header ToolbarHeader
---@field private _toolbar Toolbar
ToolbarHeaderButton = Leaf:extendAs("gui.toolbar.header.Button")

ToolbarHeaderButton.__lockedBox = Box.new():withContentSize(16)
ToolbarHeaderButton.__unlockedBox = Box.new():withContentSize(20)

---@protected
---@param element LuaGuiElement
---@return ToolbarHeaderButton
function ToolbarHeaderButton.new(element)
    return ToolbarHeaderButton:super(
            Leaf.new(
                    element,
                    ToolbarHeaderButton.isLockedElement(element) and ToolbarHeaderButton.__lockedBox or ToolbarHeaderButton.__unlockedBox))
end

function ToolbarHeaderButton:initialize()
    self._header = self:ancestor(ToolbarHeader)
    self._toolbar = self:ancestor(Toolbar)
end

---@protected
---@return boolean
function ToolbarHeaderButton:isLocked()
    return ToolbarHeaderButton.isLockedElement(self:element())
end

---@private
---@param element LuaGuiElement
function ToolbarHeaderButton.isLockedElement(element)
    return element.style.maximal_width == ToolbarHeaderButton.__lockedBox:totalWidth()
end

function ToolbarHeaderButton:lock()
    self:element().style.size = ToolbarHeaderButton.__lockedBox:totalWidth()
    self:setBox(ToolbarHeaderButton.__lockedBox)
end

function ToolbarHeaderButton:unlock()
    self:element().style.size = ToolbarHeaderButton.__unlockedBox:totalWidth()
    self:setBox(ToolbarHeaderButton.__unlockedBox)
end

---@protected
---@return ToolbarHeader
function ToolbarHeaderButton:header()
    return self._header
end

---@protected
---@return Toolbar
function ToolbarHeaderButton:toolbar()
    return self._toolbar
end

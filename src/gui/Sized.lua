import("gui.Component")

---@class Sized : Component
---@field private _box Box
---
---@field private _displayWidth number
---@field private _width number
---@field private _displayHeight number
---@field private _height number
Sized = Component:extendAs("gui.Sized")

function Sized.create(class, parent, addParameters, builder)
    local instance = Component.create(class, parent, addParameters, builder)
    instance:fireSizeChanged()
    return instance
end

---@protected
---@param element LuaGuiElement
---@param childrenClasses Component[]
---@param box Box
function Sized.new(element, childrenClasses, box)
    local this = Sized:super(Component.new(element, childrenClasses))
    this._box = box or Box.none()
    return this
end

---@protected
---@param box Box
function Sized:setBox(box)
    self._box = box
    self:fireSizeChanged()
end

function Sized:show()
    Sized:super().show(self)
    self:fireSizeChanged()
end

function Sized:hide()
    Sized:super().hide(self)
    self:fireSizeChanged()
end

---@protected
function Sized:fireSizeChanged()
    self:onSizeChanged()
end

---@protected
function Sized:onSizeChanged()
    self:onWidthChanged()
    self:onHeightChanged()
end

---@protected
function Sized:onWidthChanged()
    local widthChanged = self:refreshWidth()
    local displayWidthChanged = self:refreshDisplayWidth()
    if (widthChanged or displayWidthChanged) and self:isChild() then
        self:parent():cast(Sized):onWidthChanged()
    end
end

---@public
---@return number
function Sized:width()
    --local previousWidth = self._width
    if self._width == nil then
        self:refreshWidth()
    end
    --Log:append(self:className() .. ": " .. (previousWidth and previousWidth or "nil") .. "->" .. self._width)
    return self._width
end

---@private
---@return boolean changed
function Sized:refreshWidth()
    local previousWidth = self._width
    self._width = self:freshWidth()
    return self._width ~= previousWidth
end

---@protected
---@return number
function Sized:freshWidth()
    error("Not implemented")
end

---@public
---@return number
function Sized:displayWidth()
    --local previousDisplayWidth = self._displayWidth
    if self._displayWidth == nil then
        self:refreshDisplayWidth()
    end
    --Log:append(self:className() .. ": " .. (previousDisplayWidth and previousDisplayWidth or "nil") .. "->" .. self._displayWidth)
    return self._displayWidth
end

---@private
---@return boolean changed
function Sized:refreshDisplayWidth()
    local previousDisplayWidth = self._displayWidth
    self._displayWidth = self:freshDisplayWidth()
    return self._displayWidth ~= previousDisplayWidth
end

---@protected
---@return number
function Sized:freshDisplayWidth()
    error("Not implemented")
end

---@protected
function Sized:onHeightChanged()
    local heightChanged = self:refreshHeight()
    local displayHeightChanged = self:refreshDisplayHeight()
    if (heightChanged or displayHeightChanged) and self:isChild() then
        self:parent():cast(Sized):onHeightChanged()
    end
end

---@public
---@return number
function Sized:height()
    --local previousHeight = self._height
    if self._height == nil then
        self:refreshHeight()
    end
    --Log:append(self:className() .. ": " .. (previousHeight and previousHeight or "nil") .. "->" .. self._height)
    return self._height
end

---@private
---@return boolean changed
function Sized:refreshHeight()
    local previousHeight = self._height
    self._height = self:freshHeight()
    return self._height ~= previousHeight
end

---@protected
---@return number
function Sized:freshHeight()
    error("Not implemented")
end

---@public
---@return number
function Sized:displayHeight()
    --local previousDisplayHeight = self._displayHeight
    if self._displayHeight == nil then
        self:refreshDisplayHeight()
    end
    --Log:append(self:className() .. ": " .. (previousDisplayHeight and previousDisplayHeight or "nil") .. "->" .. self._displayHeight)
    return self._displayHeight
end

---@private
---@return boolean changed
function Sized:refreshDisplayHeight()
    local previousDisplayHeight = self._displayHeight
    self._displayHeight = self:freshDisplayHeight()
    return self._displayHeight ~= previousDisplayHeight
end

---@protected
---@return number
function Sized:freshDisplayHeight()
    error("Not implemented")
end

---@protected
---@return Box
function Sized:box()
    return self._box
end

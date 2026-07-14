import("gui.Leaf")

---@class Strut : Leaf
---@field private _width number
Strut = Leaf:extendAs("gui.toolbar.Strut")

---@public
---@param parent Component
---@return Strut
function Strut.create(parent)
    return Leaf.create(Strut, parent, { type = "empty-widget" })
end

---@protected
---@param element LuaGuiElement
---@return Strut
function Strut.new(element)
    local width = element.style.minimal_width or 0
    return Strut:super(Leaf.new(element, Box.new():withWidth(width)))
end

---@public
---@param width number
function Strut:setFixedWidth(width)
    self:element().style.minimal_width = width
    self:setBox(Box.new():withWidth(width))
end

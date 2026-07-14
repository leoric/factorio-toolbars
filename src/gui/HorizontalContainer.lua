import("gui.Container")
import("gui.Sized")

---@class HorizontalContainer : Container
HorizontalContainer = Container:extendAs("gui.HorizontalContainer")

---@protected
---@generic C : Component
---@param class C
---@param parent Component
---@param addParameters LuaGuiElement.add_parameters optional
---@param builder fun(instance: C):void optional
---@return C
function HorizontalContainer.create(class, parent, addParameters, builder)
    addParameters.direction = "horizontal"
    return Container.create(class, parent, addParameters, builder)
end

---@protected
---@param element LuaGuiElement
---@param childrenClasses Sized[]
---@param box Box
function HorizontalContainer.new(element, childrenClasses, box)
    return HorizontalContainer:super(Container.new(element, childrenClasses, box))
end

function HorizontalContainer:freshWidth()
    local width = 0
    for _, child in ipairs(self:children()) do
        width = width + child:cast(Sized):width()
    end
    return width + self:box():totalWidthSpacing() + self:extraSpacing()
end

function HorizontalContainer:freshDisplayWidth()
    if not self:isVisible() then
        return 0
    end

    local displayWidth = 0
    for _, child in ipairs(self:children()) do
        displayWidth = displayWidth + child:cast(Sized):displayWidth()
    end
    return displayWidth + self:box():scale(self:display():scaleValue()):totalWidthSpacing() + self:display():scale(self:extraSpacing())
end

function HorizontalContainer:freshHeight()
    local biggestChildHeight = 0
    for _, child in ipairs(self:children()) do
        if child:height() > biggestChildHeight then
            biggestChildHeight = child:cast(Sized):height()
        end
    end
    return biggestChildHeight + self:box():totalHeightSpacing()
end

function HorizontalContainer:freshDisplayHeight()
    if not self:isVisible() then
        return 0
    end

    local biggestChildDisplayHeight = 0
    for _, child in ipairs(self:children()) do
        if child:displayHeight() > biggestChildDisplayHeight then
            biggestChildDisplayHeight = child:cast(Sized):displayHeight()
        end
    end
    return biggestChildDisplayHeight + self:box():scale(self:display():scaleValue()):totalHeightSpacing()
end

---@protected
---@return number
function HorizontalContainer:extraSpacing()
    return 0
end

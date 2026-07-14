import("gui.Container")
import("gui.Sized")

---@class VerticalContainer : Container
VerticalContainer = Container:extendAs("gui.VerticalContainer")

---@protected
---@generic C : Component
---@param class C
---@param parent Component
---@param addParameters LuaGuiElement.add_parameters
---@param builder fun(instance: C):void optional
---@return C
function VerticalContainer.create(class, parent, addParameters, builder)
    addParameters.direction = "vertical"
    return Container.create(class, parent, addParameters, builder)
end

---@protected
---@param element LuaGuiElement
---@param childrenClasses Component[]
---@param box Box
---@return VerticalContainer
function VerticalContainer.new(element, childrenClasses, box)
    return VerticalContainer:super(Container.new(element, childrenClasses, box))
end

function VerticalContainer:freshWidth()
    local biggestChildWidth = 0
    for _, child in ipairs(self:children()) do
        if child:width() > biggestChildWidth then
            biggestChildWidth = child:cast(Sized):width()
        end
    end
    return biggestChildWidth + self:box():totalWidthSpacing()
end

function VerticalContainer:freshDisplayWidth()
    if not self:isVisible() then
        return 0
    end

    local biggestChildDisplayWidth = 0
    for _, child in ipairs(self:children()) do
        if child:displayWidth() > biggestChildDisplayWidth then
            biggestChildDisplayWidth = child:cast(Sized):displayWidth()
        end
    end
    return biggestChildDisplayWidth + self:box():scale(self:display():scaleValue()):totalWidthSpacing()
end

function VerticalContainer:freshHeight()
    local height = 0
    for _, child in ipairs(self:children()) do
        height = height + child:cast(Sized):height()
    end
    return height + self:box():totalHeightSpacing() + self:extraSpacing()
end

function VerticalContainer:freshDisplayHeight()
    if not self:isVisible() then
        return 0
    end

    local displayHeight = 0
    for _, child in ipairs(self:children()) do
        displayHeight = displayHeight + child:cast(Sized):displayHeight()
    end
    return displayHeight + self:box():scale(self:display():scaleValue()):totalHeightSpacing() + self:display():scale(self:extraSpacing())
end

function VerticalContainer:extraSpacing()
    return 0
end

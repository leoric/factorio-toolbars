import("gui.Sized")

---@class Container : Sized
Container = Sized:extendAs("gui.Container")

---@protected
---@param element LuaGuiElement
---@param childrenClasses Component[]
---@param box Box
function Container.new(element, childrenClasses, box)
    return Container:super(Sized.new(element, childrenClasses, box))
end

-----@protected
-----@param childToAdd Component
--function Container:addChild(childToAdd)
--    Container:super().addChild(self, childToAdd)
--    self:fireSizeChanged()
--end

---@protected
---@param childToRemove Component
function Container:removeChild(childToRemove)
    Container:super().removeChild(self, childToRemove)
    self:fireSizeChanged()
end

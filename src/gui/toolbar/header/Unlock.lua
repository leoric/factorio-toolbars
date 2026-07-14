import("gui.toolbar.header.ToolbarHeaderButton")
import("gui.toolbar.header.Lock")

---@class Unlock : ToolbarHeaderButton
Unlock = ToolbarHeaderButton:extendAs("gui.toolbar.header.Unlock")

---@public
---@param parent Component
---@return Unlock
function Unlock.create(parent)
    return Component.create(
            Unlock,
            parent,
            {
                type = "sprite-button",
                sprite = Toolbars.icons.padlockClosed,
                style = "toolbar_header_unlock"
            },
            function(instance)
                instance:lock()
            end
    )
end

---@protected
---@param element LuaGuiElement
---@return Unlock
function Unlock.new(element)
    return Unlock:super(ToolbarHeaderButton.new(element))
end

function Unlock:onClick(click)
    if click:isLeft() then
        self:toolbar():unlock()
    end
end

function Unlock:unlock()
    self:replaceWith(Lock.create(self:parent()))
end

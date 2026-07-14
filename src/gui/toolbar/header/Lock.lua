import("gui.toolbar.header.ToolbarHeaderButton")
import("gui.toolbar.header.Unlock")

---@class Lock : ToolbarHeaderButton
Lock = ToolbarHeaderButton:extendAs("gui.toolbar.header.Lock")

---@public
---@param parent Component
---@return Lock
function Lock.create(parent)
    return ToolbarHeaderButton.create(
            Lock,
            parent,
            {
                type = "sprite-button",
                sprite = Toolbars.icons.padlockOpen,
                style = "toolbar_header_lock"
            }
    )
end

---@public
---@param element LuaGuiElement
---@return Lock
function Lock.new(element)
    return Lock:super(ToolbarHeaderButton.new(element))
end

function Lock:onClick(click)
    if click:isLeft() then
        self:toolbar():lock()
    end
end

function Lock:lock()
    self:replaceWith(Unlock.create(self:parent()))
end

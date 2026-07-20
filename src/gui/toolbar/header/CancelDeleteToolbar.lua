import("gui.toolbar.header.ToolbarHeaderButton")

---@class CancelDeleteToolbar : ToolbarHeaderButton
CancelDeleteToolbar = ToolbarHeaderButton:extendAs("gui.toolbar.header.CancelDelete")

---@public
---@param parent Component
---@return CancelDeleteToolbar
function CancelDeleteToolbar.create(parent)
    return ToolbarHeaderButton.create(
            CancelDeleteToolbar,
            parent,
            {
                type = "sprite-button",
                sprite = Toolbars.icons.cancel,
                style = "toolbar_header_cancelDelete"
            }
    )
end

---@public
---@param element LuaGuiElement
---@return CancelDeleteToolbar
function CancelDeleteToolbar.new(element)
    return CancelDeleteToolbar:super(ToolbarHeaderButton.new(element))
end

function CancelDeleteToolbar:onClick(click)
    if click:isLeft() then
        self:header():cancelDeletion()
    end
end

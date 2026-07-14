import("gui.toolbar.header.ToolbarHeaderButton")

---@class ConfirmDeleteToolbar : ToolbarHeaderButton
ConfirmDeleteToolbar = ToolbarHeaderButton:extendAs("gui.toolbar.header.ConfirmDelete")

---@public
---@param parent Component
---@return ConfirmDeleteToolbar
function ConfirmDeleteToolbar.create(parent)
    return ToolbarHeaderButton.create(
            ConfirmDeleteToolbar,
            parent,
            {
                type = "sprite-button",
                sprite = Toolbars.icons.confirm,
                style = "toolbar_header_confirmDelete"
            }
    )
end

---@protected
---@param element LuaGuiElement
---@return ConfirmDeleteToolbar
function ConfirmDeleteToolbar.new(element)
    return ConfirmDeleteToolbar:super(ToolbarHeaderButton.new(element))
end

function ConfirmDeleteToolbar:onClick(click)
    if click:isLeft() then
        self:toolbar():delete()
    end
end

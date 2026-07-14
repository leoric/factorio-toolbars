import("gui.toolbar.header.ToolbarHeaderButton")

---@class DeleteToolbar : ToolbarHeaderButton
DeleteToolbar = ToolbarHeaderButton:extendAs("gui.toolbar.header.Delete")

---@public
---@param parent Component
---@return DeleteToolbar
function DeleteToolbar.create(parent)
    return ToolbarHeaderButton.create(
            DeleteToolbar,
            parent,
            {
                type = "sprite-button",
                sprite = "utility/trash",
                style = "toolbar_header_delete"
            }
    )
end

---@public
---@param element LuaGuiElement
---@return DeleteToolbar
function DeleteToolbar.new(element)
    return DeleteToolbar:super(ToolbarHeaderButton.new(element))
end

function DeleteToolbar:onClick(click)
    if click:isLeft() then
        self:header():askForDeletion()
    end
end

function DeleteToolbar:lock()
    self:hide()
end

function DeleteToolbar:unlock()
    self:show()
end

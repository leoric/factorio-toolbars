import("gui.toolbar.header.ToolbarHeaderButton")
import("gui.toolbar.header.CollapseToolbar")

---@class ExpandToolbar : ToolbarHeaderButton
ExpandToolbar = ToolbarHeaderButton:extendAs("gui.toolbar.header.Expand")

---@public
---@param parent Component
---@return ExpandToolbar
function ExpandToolbar.create(parent)
    return ToolbarHeaderButton.create(
            ExpandToolbar,
            parent,
            {
                type = "sprite-button",
                sprite = Toolbars.icons.expand,
                style = "toolbar_header_expand"
            }
    )
end

---@public
---@param element LuaGuiElement
---@return ExpandToolbar
function ExpandToolbar.new(element)
    return ExpandToolbar:super(ToolbarHeaderButton.new(element))
end

function ExpandToolbar:initialize()
    ExpandToolbar:super().initialize(self)
    self:migrateTo_2_16_0()
end

function ExpandToolbar:migrateTo_2_16_0()
    self:element().sprite = Toolbars.icons.expand
end

function ExpandToolbar:onClick(click)
    if click:isLeft() then
        self:toolbar():expand()
    end
end

---@public
function ExpandToolbar:expanded()
    local collapse = CollapseToolbar.create(self:parent())
    if self:isLocked() then
        collapse:lock()
    end
    self:replaceWith(collapse)
end

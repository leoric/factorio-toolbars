import("gui.toolbar.header.ToolbarHeaderButton")

---@class CollapseToolbar : ToolbarHeaderButton
CollapseToolbar = ToolbarHeaderButton:extendAs("gui.toolbar.header.Collapse")

---@public
---@param parent Component
---@return CollapseToolbar
function CollapseToolbar.create(parent)
    return ToolbarHeaderButton.create(
            CollapseToolbar,
            parent,
            {
                type = "sprite-button",
                style = "toolbar_header_collapse"
            }
    )
end

---@protected
---@param element LuaGuiElement
---@return CollapseToolbar
function CollapseToolbar.new(element)
    return CollapseToolbar:super(ToolbarHeaderButton.new(element))
end

function CollapseToolbar:initialize()
    CollapseToolbar:super().initialize(self)
    if self:toolbar():isAlignedTop() then
        self:alignTop()
    else
        self:alignBottom()
    end
end

function CollapseToolbar:onClick(click)
    if click:isLeft() then
        self:toolbar():collapse()
    end
end

---@public
function CollapseToolbar:collapsed()
    local expand = ExpandToolbar.create(self:parent())
    if self:isLocked() then
        expand:lock()
    end
    self:replaceWith(expand)
end

function CollapseToolbar:alignTop()
    self:element().sprite = Toolbars.icons.collapseUpward
end

function CollapseToolbar:alignBottom()
    self:element().sprite = Toolbars.icons.collapseDownward
end

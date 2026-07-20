import("gui.toolbar.header.ToolbarHeaderButton")

---@class OneSectionMode : ToolbarHeaderButton
OneSectionMode = ToolbarHeaderButton:extendAs("gui.toolbar.header.OneSectionMode")

---@public
---@param parent Component
---@param index number
---@return OneSectionMode
function OneSectionMode.create(parent, index)
    return ToolbarHeaderButton.create(
            OneSectionMode,
            parent,
            {
                type = "sprite-button",
                sprite = Toolbars.icons.one,
                style = "toolbar_header_one_section_mode",
                auto_toggle = true,
                index = index
            }
    )
end

---@protected
---@param element LuaGuiElement
---@return OneSectionMode
function OneSectionMode.new(element)
    return OneSectionMode:super(ToolbarHeaderButton.new(element))
end

function OneSectionMode:onClick(click)
    if click:isLeft() and self:toggled() then
        self:toolbar():collapseAllSections()
    end
end

---@public
---@return boolean
function OneSectionMode:toggled()
    return self:element().toggled
end

---@public
---@param value boolean
function OneSectionMode:setToggled(value)
    self:element().toggled = value
end

function OneSectionMode:lock()
    self:hide()
end

function OneSectionMode:unlock()
    self:show()
end

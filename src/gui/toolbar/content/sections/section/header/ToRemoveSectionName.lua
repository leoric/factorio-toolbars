import("gui.Leaf")
import("gui.Box")
import("gui.toolbar.content.sections.section.header.SectionNameLocked")
import("gui.toolbar.content.sections.section.header.SectionNameUnlocked")

--- migrate to 2.30.0
---@class ToRemoveSectionName : SectionHeaderButton
ToRemoveSectionName = SectionHeaderButton:extendAs("gui.toolbar.content.sections.section.header.Name")

---@public
---@param parent Component
---@return ToRemoveSectionName
function ToRemoveSectionName.create(parent)
    return SectionHeaderButton.create(
            ToRemoveSectionName,
            parent,
            {
                type = "textfield",
                style = "toolbar_content_sections_section_header_name"
            },
            function(instance)
                instance:element().lose_focus_on_confirm = true
            end
    )
end

---@protected
---@param element LuaGuiElement
---@return ToRemoveSectionName
function ToRemoveSectionName.new(element)
    return ToRemoveSectionName:super(SectionHeaderButton.new(element))
end

function ToRemoveSectionName:lock()
    self:replaceWith(SectionNameLocked.create(self:parent(), self:text()))
end

function ToRemoveSectionName:unlock()
    self:replaceWith(SectionNameUnlocked.create(self:parent(), self:text()))
end

---@public
---@return string
function ToRemoveSectionName:text()
    return self:element().text
end

---@public
---@param text string
function ToRemoveSectionName:setText(text)
    self:element().text = text
end

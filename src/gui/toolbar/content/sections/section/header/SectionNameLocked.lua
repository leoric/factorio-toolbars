import("gui.Leaf")
import("gui.Box")
import("gui.toolbar.content.sections.section.header.SectionNameUnlocked")

---@class SectionNameLocked : SectionHeaderButton
SectionNameLocked = SectionHeaderButton:extendAs("gui.toolbar.content.sections.section.header.SectionNameLocked")

---@public
---@param parent Component
---@param text string
---@return SectionNameLocked
function SectionNameLocked.create(parent, text)
    return SectionHeaderButton.create(
            SectionNameLocked,
            parent,
            {
                type = "textfield",
                style = "toolbar_content_sections_section_header_name",
                enabled = false,
                ignored_by_interaction = true,
                text = text
            }
    )
end

---@protected
---@param element LuaGuiElement
---@return SectionNameLocked
function SectionNameLocked.new(element)
    return SectionNameLocked:super(SectionHeaderButton.new(element))
end

function SectionNameLocked:unlock()
    self:replaceWith(SectionNameUnlocked.create(self:parent(), self:text()))
end

---@public
---@return string
function SectionNameLocked:text()
    return self:element().text
end

---@public
---@param text string
function SectionNameLocked:setText(text)
    self:element().text = text
end

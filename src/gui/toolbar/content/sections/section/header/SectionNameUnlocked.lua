import("gui.Leaf")
import("gui.Box")
import("gui.toolbar.content.sections.section.header.SectionNameLocked")

---@class SectionNameUnlocked : SectionHeaderButton
SectionNameUnlocked = SectionHeaderButton:extendAs("gui.toolbar.content.sections.section.header.SectionNameUnlocked")

---@public
---@param parent Component
---@param text string
---@return SectionNameUnlocked
function SectionNameUnlocked.create(parent, text)
    return SectionHeaderButton.create(
            SectionNameUnlocked,
            parent,
            {
                type = "textfield",
                style = "toolbar_content_sections_section_header_name",
                text = text,
                icon_selector = true,
                lose_focus_on_confirm = true
            }
    )
end

---@protected
---@param element LuaGuiElement
---@return SectionNameUnlocked
function SectionNameUnlocked.new(element)
    return SectionNameUnlocked:super(SectionHeaderButton.new(element))
end

function SectionNameUnlocked:lock()
    self:replaceWith(SectionNameLocked.create(self:parent(), self:text()))
end

---@public
---@return string
function SectionNameUnlocked:text()
    return self:element().text
end

---@public
---@param text string
function SectionNameUnlocked:setText(text)
    self:element().text = text
end

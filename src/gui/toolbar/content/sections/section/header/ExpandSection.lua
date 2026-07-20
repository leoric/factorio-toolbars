import("gui.toolbar.content.sections.section.header.CollapseSection")
import("gui.toolbar.content.sections.section.header.SectionHeaderButton")

---@class ExpandSection : SectionHeaderButton
ExpandSection = SectionHeaderButton:extendAs("gui.toolbar.content.sections.section.header.Expand")

---@public
---@param parent Component
---@return ExpandSection
function ExpandSection.create(parent)
    return SectionHeaderButton.create(
            ExpandSection,
            parent,
            {
                type = "sprite-button",
                sprite = Toolbars.icons.expand,
                style = "toolbar_content_sections_section_header_expand"
            }
    )
end

---@protected
---@param element LuaGuiElement
---@return ExpandSection
function ExpandSection.new(element)
    return ExpandSection:super(SectionHeaderButton.new(element))
end

function ExpandSection:onClick(click)
    if click:isLeft() then
        self:section():expand()
    end
end

---@public
function ExpandSection:replaceWithCollapse()
    self:replaceWith(CollapseSection.create(self:parent()))
end

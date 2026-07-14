import("gui.VerticalContainer")
import("gui.toolbar.content.sections.section.content.table.Table")

---@class SectionContent : VerticalContainer
SectionContent = VerticalContainer:extendAs("gui.toolbar.content.sections.section.content.Content")

---@public
---@param parent Component
---@return SectionContent
function SectionContent.create(parent)
    return VerticalContainer.create(
            SectionContent,
            parent,
            {
                type = "flow",
                style = "toolbar_content_sections_section_content"
            },
            function(instance)
                Table.create(instance)
            end
    )
end

---@protected
---@param element LuaGuiElement
---@return SectionContent
function SectionContent.new(element)
    return SectionContent:super(VerticalContainer.new(element, { Table }))
end

---@public
---@return Table
function SectionContent:table()
    return self:child(Table)
end

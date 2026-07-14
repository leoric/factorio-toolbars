import("gui.toolbar.content.sections.section.header.SectionHeaderButton")

---@class ConfirmDeleteSection : SectionHeaderButton
ConfirmDeleteSection = SectionHeaderButton:extendAs("gui.toolbar.content.sections.section.header.ConfirmDelete")

---@public
---@param parent Component
---@return ConfirmDeleteSection
function ConfirmDeleteSection.create(parent)
    return SectionHeaderButton.create(
            ConfirmDeleteSection,
            parent,
            {
                type = "sprite-button",
                sprite = Toolbars.icons.confirm,
                style = "toolbar_content_sections_section_header_confirmDelete"
            }
    )
end

---@protected
---@param element LuaGuiElement
---@return CancelDeleteSection
function ConfirmDeleteSection.new(element)
    return ConfirmDeleteSection:super(SectionHeaderButton.new(element))
end

function ConfirmDeleteSection:onClick(click)
    if click:isLeft() then
        self:section():delete()
    end
end

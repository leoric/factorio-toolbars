import("gui.toolbar.content.sections.section.header.SectionHeaderButton")

---@class CancelDeleteSection : SectionHeaderButton
CancelDeleteSection = SectionHeaderButton:extendAs("gui.toolbar.content.sections.section.header.CancelDelete")

---@public
---@param parent Component
---@return CancelDeleteSection
function CancelDeleteSection.create(parent)
    return SectionHeaderButton.create(
            CancelDeleteSection,
            parent,
            {
                type = "sprite-button",
                sprite = Toolbars.icons.cancel,
                style = "toolbar_content_sections_section_header_cancelDelete"
            }
    )
end

---@protected
---@param element LuaGuiElement
---@return CancelDeleteSection
function CancelDeleteSection.new(element)
    return CancelDeleteSection:super(SectionHeaderButton.new(element))
end

function CancelDeleteSection:onClick(click)
    if click:isLeft() then
        self:header():cancelDeletion()
    end
end

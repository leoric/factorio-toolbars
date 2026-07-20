import("gui.toolbar.content.sections.section.header.SectionHeaderButton")

---@class DeleteSection : SectionHeaderButton
DeleteSection = SectionHeaderButton:extendAs("gui.toolbar.content.sections.section.header.Delete")

---@public
---@param parent Component
---@return DeleteSection
function DeleteSection.create(parent)
    return SectionHeaderButton.create(
            DeleteSection,
            parent,
            {
                type = "sprite-button",
                sprite = "utility/trash",
                style = "toolbar_content_sections_section_header_delete"
            }
    )
end

---@protected
---@param element LuaGuiElement
---@return DeleteSection
function DeleteSection.new(element)
    return DeleteSection:super(SectionHeaderButton.new(element))
end

function DeleteSection:onClick(click)
    if click:isLeft() then
        self:header():askForDeletion()
    end
end

function DeleteSection:lock()
    self:hide()
end

function DeleteSection:unlock()
    self:show()
end

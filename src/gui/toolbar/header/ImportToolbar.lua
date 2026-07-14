import("gui.ClipboardDialog")
import("gui.toolbar.header.ToolbarHeaderButton")

---@class ImportToolbar : ToolbarHeaderButton
ImportToolbar = ToolbarHeaderButton:extendAs("gui.toolbar.header.Import")

function ImportToolbar.create(parent, index)
    return ToolbarHeaderButton.create(
            ImportToolbar,
            parent,
            {
                type = "sprite-button",
                sprite = "utility/import_slot",
                style = "toolbar_header_import",
                index = index
            }
    )
end

function ImportToolbar.new(parent, root)
    return ImportToolbar:super(ToolbarHeaderButton.new(parent, root))
end

function ImportToolbar:onClick(click)
    if click:isLeft() then
        ClipboardDialog.showImport(self:luaPlayer(), self:toolbar())
    end
end

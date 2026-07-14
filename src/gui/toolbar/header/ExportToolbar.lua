import("gui.ClipboardDialog")
import("gui.toolbar.header.ToolbarHeaderButton")

---@class ExportToolbar : ToolbarHeaderButton
ExportToolbar = ToolbarHeaderButton:extendAs("gui.toolbar.header.Export")

function ExportToolbar.create(parent, index)
    return ToolbarHeaderButton.create(
            ExportToolbar,
            parent,
            {
                type = "sprite-button",
                sprite = "utility/export_slot",
                style = "toolbar_header_export",
                index = index
            }
    )
end

function ExportToolbar.new(parent, root)
    return ExportToolbar:super(ToolbarHeaderButton.new(parent, root))
end

function ExportToolbar:onClick(click)
    if click:isLeft() then
        ClipboardDialog.showExport(self:luaPlayer(), self:toolbar():exportItemsJson())
    end
end

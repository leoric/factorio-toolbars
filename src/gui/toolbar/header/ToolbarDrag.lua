import("gui.Leaf")
import("gui.toolbar.Toolbar")

---@class ToolbarDrag : Leaf
ToolbarDrag = Leaf:extendAs("gui.toolbar.header.ToolbarDrag")

---@public
---@param parent Component
---@return ToolbarDrag
function ToolbarDrag.create(parent)
    return Leaf.create(
            ToolbarDrag,
            parent,
            {
                type = "empty-widget",
                style = "toolbar_drag"
            },
            function(instance)
                instance:element().drag_target = instance:ancestor(Toolbar):element()
            end
    )
end

---@protected
---@param element LuaGuiElement
---@return ToolbarDrag
function ToolbarDrag.new(element)
    return ToolbarDrag:super(Leaf.new(element))
end

function ToolbarDrag:onDoubleLeftClick()
    self:luaPlayer().play_sound { path = "utility/gui_click" }
    self:ancestor(Toolbar):toggle()
end

import("gui.Component")

---@class ParametersOverlay : Component
ParametersOverlay = Component:extendAs("gui.toolbar.content.sections.section.content.table.slots.tools.parametrized.ParametersOverlay")

---@public
---@param parent Component
---@param parameters table<string>
---@return ParametersOverlay
function ParametersOverlay.create(parent, parameters)
    return Component.create(
            ParametersOverlay,
            parent, {
                type = "empty-widget",
            }
    )
end

---@protected
---@param element LuaGuiElement
---@return ParametersOverlay
function ParametersOverlay.new(element)
    return ParametersOverlay:super(Component.new(element))
end

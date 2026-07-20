import("gui.Leaf")
import("gui.Box")
import("gui.toolbar.Toolbar")

---@class AddSection : Leaf
---@field private _toolbar Toolbar
AddSection = Leaf:extendAs("gui.toolbar.content.AddSection")

---@public
---@param parent Component
---@return AddSection
function AddSection.create(parent)
    return Leaf.create(
            AddSection,
            parent,
            {
                type = "button",
                sprite = "toolbars-mod_add-section",
                style = "toolbar_content_addSection"
            },
            function(instance)
                instance:element().caption = "Add section"
            end
    )
end

---@protected
---@param element LuaGuiElement
---@return AddSection
function AddSection.new(element)
    return AddSection:super(Leaf.new(element, Toolbars.styles.toolbar.content.addSection.box))
end

function AddSection:initialize()
    self._toolbar = self:ancestor(Toolbar)
end

function AddSection:onClick(click)
    if click:isLeft() then
        self._toolbar:addSection()
    end
end

function AddSection:lock()
    self:hide()
end

function AddSection:unlock()
    self:show()
end

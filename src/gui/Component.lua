---@class Component : Object
---@field private _player Player
---@field private _gui Gui
---@field private _parent Component
---@field private _element LuaGuiElement
---@field private _childrenClasses Component[]
---@field private _children Component[]
---@field private _childrenByClass Component[]
---@field private _controls table<Event, fun(event: Event):void>
---@field private _hoverEventHandlers table<Event, fun(event: Event):void>
---@field private _hoverCounter number
---@field private _lastLeftClickTick number
---@field private _lastLeftClickElementIndex string
Component = Object:extendAs("gui.Component")

---Sets element.tags.className to value of self.__className to recognize it while searching
---@protected
---@generic C : Component
---@param class C
---@param parent Component
---@param addParameters LuaGuiElement.add_parameters optional
---@param builder fun(instance: C):void optional
---@return C
function Component.create(class, parent, addParameters, builder)
    local tags = addParameters.tags and addParameters.tags or {}
    tags.className = class:className()
    addParameters.tags = tags
    addParameters.raise_hover_events = true
    local instance = class.new(parent:element().add(addParameters))
    instance:setParent(parent)
    if builder then
        builder(instance)
    end
    instance:propagateInitialization()
    return instance
end

---@protected
---@param element LuaGuiElement
---@param childrenClasses Component[] optional
---@return Component
function Component.new(element, childrenClasses)
    local this = Component:super(Object.new())
    this._element = element
    this._childrenClasses = childrenClasses and childrenClasses or {}

    this._children = {}
    this._childrenByClass = {}
    for _, class in ipairs(this._childrenClasses) do
        this._childrenByClass[class] = {}
    end
    this._controls = {}
    this._hoverEventHandlers = {}
    this._hoverCounter = 0
    this._lastLeftClickTick = 0
    this._lastLeftClickElementIndex = nil
    this:migrateTo_2_0_9()
    return this
end

---@private
function Component:migrateTo_2_0_9()
    self._element.raise_hover_events = true
end

---@protected
---@param player Player
function Component:setPlayer(player)
    self._player = player
end

---@protected
---@param gui Gui
function Component:setGui(gui)
    self._gui = gui
end

---@protected
function Component:loadChildren()
    for _, childClass in ipairs(self._childrenClasses) do
        for _, childElement in ipairs(self._element.children) do
            if childClass:isRepresentedBy(childElement) then
                childClass.new(childElement):setParent(self)
            end
        end
    end
end

---@private
---@param parent Component
function Component:setParent(parent)
    self._parent = parent
    self._player = parent._player
    self._gui = parent._gui
    self._parent:addChild(self)
    self._gui:addDescendant(self)
end

---@protected
function Component:propagateInitialization()
    for _, child in ipairs(self:children()) do
        child:propagateInitialization()
    end
    self:initialize()
end

---@protected
function Component:initialize()
end

---@protected
---@param childToAdd Component
function Component:addChild(childToAdd)
    self:addChildToChildren(childToAdd)
    self:addChildToChildrenByClass(childToAdd)
end

---@private
---@param childToAdd Component
function Component:addChildToChildren(childToAdd)
    local updatedChildren = {}
    for i, child in ipairs(self._children) do
        updatedChildren[i] = child
    end
    updatedChildren[#updatedChildren + 1] = childToAdd
    self._children = updatedChildren
end

---@private
---@param childToAdd Component
function Component:addChildToChildrenByClass(childToAdd)
    local updatedChildrenForClass = {}
    for i, child in ipairs(self._childrenByClass[childToAdd:class()]) do
        updatedChildrenForClass[i] = child
    end
    updatedChildrenForClass[#updatedChildrenForClass + 1] = childToAdd
    self._childrenByClass[childToAdd:class()] = updatedChildrenForClass
end

---@protected
---@return boolean
function Component:isRoot()
    return self._parent == nil
end

---@protected
---@return boolean
function Component:isChild()
    return self._parent ~= nil
end

---@public
function Component:delete()
    self._gui:removeDescendant(self)
    self._player:eventBus():unsubscribeFromAll(self)

    self:deleteChildren()
    if self:isHovered() then
        self:propagateOnLeave()
    end
    self._parent:removeChild(self)
    self._element.destroy()
end

---@private
function Component:deleteChildren()
    for _, child in ipairs(self:children()) do
        child:delete()
    end
end

---@protected
---@param childToRemove Component
function Component:removeChild(childToRemove)
    self:removeFromChildren(childToRemove)
    self:removeFromChildrenByClass(childToRemove)
end

---@private
---@param childToRemove Component
function Component:removeFromChildren(childToRemove)
    local index = 1
    local updatedChildren = {}
    for i, child in ipairs(self._children) do
        if (child ~= childToRemove) then
            updatedChildren[index] = child
            index = index + 1
        end
    end
    self._children = updatedChildren
end

---@private
---@param childToRemove Component
function Component:removeFromChildrenByClass(childToRemove)
    if self._childrenByClass[childToRemove:class()] ~= nil and next(self._childrenByClass[childToRemove:class()]) ~= nil then
        local index = 1
        local updatedChildrenByClass = {}
        for i, child in ipairs(self._childrenByClass[childToRemove:class()]) do
            if child ~= childToRemove then
                updatedChildrenByClass[index] = child
                index = index + 1
            end
        end
        self._childrenByClass[childToRemove:class()] = updatedChildrenByClass
    end
end

---@public
---@param click Click
function Component:propagateOnClick(click)
    if click:isLeft() then
        if (click:elementIndex() == self._lastLeftClickElementIndex) and (click:tick() - self._lastLeftClickTick < 20) then
            -- 300 ms/16 ms/tick = 18.75 tick
            self:onDoubleLeftClick()
        else
            self:onClick(click)
        end
        self._lastLeftClickTick = click:tick()
        self._lastLeftClickElementIndex = click:elementIndex()
    else
        self:onClick(click)
    end

    self._parent:propagateOnClick(click)
end

---@public
---@param click Click
function Component:onClick(click)
end

function Component:onDoubleLeftClick()
end

---@public
function Component:propagateOnElementChanged()
    self:onElementChanged()
    self._parent:propagateOnElementChanged()
end

---@public
function Component:onElementChanged()
end

---@public
function Component:propagateOnElementLocationChanged()
    self:onElementLocationChanged()
    self._parent:onElementLocationChanged()
end

---@public
function Component:onElementLocationChanged()
end

---@public
---@return boolean
function Component:isHovered()
    return self._hoverCounter > 0
end

function Component:propagateOnHover()
    self._hoverCounter = self._hoverCounter + 1
    if self._hoverCounter == 1 then
        self:registerControls()
        self:registerHoverEventHandlers()

        self:onHover()
    end
    self:parent():propagateOnHover()
end

---@public
function Component:onHover()
end

---@private
function Component:registerControls()
    for control, handler in pairs(self._controls) do
        self._player:eventBus():subscribeTo(control, self, handler)
    end
end

---@private
function Component:registerHoverEventHandlers()
    for event, handler in pairs(self._hoverEventHandlers) do
        self._player:eventBus():subscribeTo(event, self, handler)
    end
end

---@public
function Component:propagateOnLeave()
    self._hoverCounter = math.max(0, self._hoverCounter - 1)
    if self._hoverCounter == 0 then
        self:unregisterControls()
        self:unregisterHoverEventHandlers()

        self:onLeave()
    end
    self:parent():propagateOnLeave()
end

---@public
function Component:onLeave()
end

---@private
function Component:unregisterControls()
    for control, _ in pairs(self._controls) do
        self._player:eventBus():unsubscribeFrom(control, self)
    end
end

---@private
function Component:unregisterHoverEventHandlers()
    for event, _ in pairs(self._hoverEventHandlers) do
        self._player:eventBus():unsubscribeFrom(event, self)
    end
end

---@public
---@generic E : Event
---@param controls table<E, fun(event: E):void>
function Component:setControls(controls)
    self._controls = controls
end

---@public
---@generic E : Event
---@param event E
---@param handler fun(event: E):void
function Component:addHoverEventHandler(event, handler)
    self._hoverEventHandlers[event] = handler
end

---@public
---@generic E : Event
---@param hoverEventHandlers table<E,fun(event: E):void>
function Component:setHoverEventHandlers(hoverEventHandlers)
    self._hoverEventHandlers = hoverEventHandlers
end

---@public
function Component:lock()
    for _, child in ipairs(self:children()) do
        child:lock()
    end
end

---@public
function Component:unlock()
    for _, child in ipairs(self:children()) do
        child:unlock()
    end
end

---@public
function Component:alignTop()
    for _, child in ipairs(self:children()) do
        child:alignTop()
    end
end

---@public
function Component:alignBottom()
    for _, child in ipairs(self:children()) do
        child:alignBottom()
    end
end

---@public
---@return self[]
function Component:siblingsAndMe()
    return self._parent:children(self:class())
end

---@public
---@generic T : Component
---@param class T
---@return T
function Component:child(class)
    return self:children(class)[1]
end

---@public
---@generic T : Component
---@param class T @optional
---@return T[]
function Component:children(class)
    if class then
        return self._childrenByClass[class]
    else
        return self._children
    end
end

---[STATIC]
---@public
---@param element LuaGuiElement
---@return boolean
function Component:isRepresentedBy(element)
    return element.tags and element.tags.className == self:className()
end

---@public
---@generic T : Component
---@param class T
---@return T
function Component:ancestor(class)
    return self._parent:findAncestor(class)
end

---@private
---@generic T : Component
---@param class T
---@return T
function Component:findAncestor(class)
    if self:isInstanceOf(class) then
        return self
    elseif self:isChild() then
        return self._parent:findAncestor(class)
    else
        error("Has no ancestor of type: " .. class:className())
    end
end

---@public
---@param replacement Component
function Component:replaceWith(replacement)
    self:swapWith(replacement)
    self:delete()
end

---@public
---@param other Component
function Component:swapWith(other)
    self._parent:element().swap_children(self:index(), other:index())
end

---@public
---@return boolean
function Component:isValid()
    return self._element.valid
end

---@public
function Component:show()
    self._element.visible = true
end

---@public
function Component:hide()
    self._element.visible = false
end

---@public
---@return boolean
function Component:isVisible()
    return self._element.visible
end

---@protected
---@return number
function Component:index()
    return self._element.get_index_in_parent()
end

---@protected
---@return Component
function Component:parent()
    return self._parent
end

---@public
---@return LuaGuiElement
function Component:element()
    return self._element
end

---@public
---@param name string
---@param value boolean|number|string|table
function Component:setTag(name, value)
    local tags = self:element().tags
    tags[name] = value
    self:element().tags = tags
end

--- Maps with `number keys` are returned with `string keys` because tags are deserialized from json
---@public
---@param name string
---@return boolean|number|string|table
function Component:getTag(name)
    return self:element().tags[name]
end

---@protected
---@return Resolution
function Component:resolution()
    return self:display():resolution()
end

---@protected
---@return number
function Component:scale(size)
    return self:display():scale(size)
end

---@protected
---@return Display
function Component:display()
    return self._player:display()
end

---@protected
---@return LuaPlayer
function Component:luaPlayer()
    return self._player:luaPlayer()
end

---@protected
---@return Player
function Component:player()
    return self._player
end

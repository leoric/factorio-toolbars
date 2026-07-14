---A lightweight, non-Component popup used to bridge Factorio's lack of direct
---clipboard read/write access: it shows text pre-selected for the player to
---Ctrl+C, or an empty box for the player to Ctrl+V into before confirming.
---@class ClipboardDialog
ClipboardDialog = {}

---@private
ClipboardDialog.__frameName = Toolbars.prefix("clipboard-dialog")

---@private
---@type table<number, fun(jsonText: string):void>
ClipboardDialog.__pendingImports = {}

---@private
---@param luaPlayer LuaPlayer
---@return LuaGuiElement|nil
function ClipboardDialog.__existing(luaPlayer)
    return luaPlayer.gui.screen[ClipboardDialog.__frameName]
end

---@private
---@param luaPlayer LuaPlayer
function ClipboardDialog.__close(luaPlayer)
    local existing = ClipboardDialog.__existing(luaPlayer)
    if existing then
        existing.destroy()
    end
    ClipboardDialog.__pendingImports[luaPlayer.index] = nil
end

---@private
---@param luaPlayer LuaPlayer
---@param title string
---@return LuaGuiElement frame
function ClipboardDialog.__createFrame(luaPlayer, title)
    ClipboardDialog.__close(luaPlayer)

    local frame = luaPlayer.gui.screen.add {
        type = "frame",
        name = ClipboardDialog.__frameName,
        caption = title,
        direction = "vertical"
    }
    frame.auto_center = true
    return frame
end

---@private
ClipboardDialog.__textBoxName = Toolbars.prefix("clipboard-dialog-text")

---@private
---@param frame LuaGuiElement
---@param text string
---@param readOnly boolean
---@return LuaGuiElement textBox
function ClipboardDialog.__addTextBox(frame, text, readOnly)
    local textBox = frame.add {
        type = "text-box",
        name = ClipboardDialog.__textBoxName,
        text = text
    }
    textBox.style.width = 420
    textBox.style.height = 160
    textBox.word_wrap = true
    textBox.read_only = readOnly
    return textBox
end

---@private
---@param frame LuaGuiElement
---@return LuaGuiElement buttons
function ClipboardDialog.__addButtonsRow(frame)
    local buttons = frame.add { type = "flow", direction = "horizontal" }
    buttons.style.top_margin = 8
    buttons.style.horizontally_stretchable = true
    buttons.style.horizontal_align = "right"
    return buttons
end

---Shows text as JSON, pre-selected so the player can press Ctrl+C.
---@public
---@param luaPlayer LuaPlayer
---@param jsonText string
---@param title string|nil
function ClipboardDialog.showExport(luaPlayer, jsonText, title)
    local frame = ClipboardDialog.__createFrame(luaPlayer, title or "Export toolbar")

    frame.add {
        type = "label",
        caption = "Press Ctrl+C to copy the text below, then close this window."
    }

    local textBox = ClipboardDialog.__addTextBox(frame, jsonText, true)

    local buttons = ClipboardDialog.__addButtonsRow(frame)
    buttons.add {
        type = "button",
        caption = "Close",
        tags = { toolbarsModClipboardAction = "close" }
    }

    luaPlayer.opened = frame
    textBox.focus()
    textBox.select_all()
end

---Shows an empty box for the player to Ctrl+V into, then calls onImport with
---whatever text was pasted once the player clicks Import.
---@private
---@param luaPlayer LuaPlayer
---@param title string
---@param onImport fun(jsonText: string):void
function ClipboardDialog.__showImport(luaPlayer, title, onImport)
    local frame = ClipboardDialog.__createFrame(luaPlayer, title)

    frame.add {
        type = "label",
        caption = "Press Ctrl+V to paste below, then click Import."
    }

    local textBox = ClipboardDialog.__addTextBox(frame, "", false)

    local buttons = ClipboardDialog.__addButtonsRow(frame)
    buttons.add {
        type = "button",
        caption = "Cancel",
        tags = { toolbarsModClipboardAction = "cancel" }
    }
    buttons.add {
        type = "button",
        caption = "Import",
        tags = { toolbarsModClipboardAction = "import" }
    }

    ClipboardDialog.__pendingImports[luaPlayer.index] = onImport

    luaPlayer.opened = frame
    textBox.focus()
end

---Imports items into a single toolbar's empty slots.
---@public
---@param luaPlayer LuaPlayer
---@param toolbar Toolbar
function ClipboardDialog.showImport(luaPlayer, toolbar)
    ClipboardDialog.__showImport(luaPlayer, "Import toolbar", function(jsonText)
        if toolbar:isValid() then
            toolbar:importItemsFromJson(jsonText)
        end
    end)
end

---Replaces every toolbar with the ones described in the pasted JSON.
---@public
---@param luaPlayer LuaPlayer
---@param gui Gui
function ClipboardDialog.showImportAllToolbars(luaPlayer, gui)
    ClipboardDialog.__showImport(luaPlayer, "Import all toolbars", function(jsonText)
        gui:importToolbarsFromJson(jsonText)
    end)
end

---@public
---@param event EventData.on_gui_click
function ClipboardDialog.handleClick(event)
    local element = event.element
    if not (element and element.valid) then
        return
    end
    local action = element.tags.toolbarsModClipboardAction
    if not action then
        return
    end

    local luaPlayer = game.get_player(event.player_index)
    if action == "import" then
        local onImport = ClipboardDialog.__pendingImports[luaPlayer.index]
        local frame = ClipboardDialog.__existing(luaPlayer)
        local textBox = frame and frame[ClipboardDialog.__textBoxName]
        if onImport and textBox and textBox.valid then
            onImport(textBox.text)
        end
        ClipboardDialog.__close(luaPlayer)
    else
        ClipboardDialog.__close(luaPlayer)
    end
end

---@public
---@param event EventData.on_gui_closed
function ClipboardDialog.handleClosed(event)
    local element = event.element
    if element and element.valid and element.name == ClipboardDialog.__frameName then
        ClipboardDialog.__close(game.get_player(event.player_index))
    end
end

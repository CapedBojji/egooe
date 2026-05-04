# egooe API Reference

egooe is an immediate-mode UI framework for Roblox. Every frame you call widget functions in order; the framework diffs the result and updates the GUI instances for you. State persists across frames via hooks.

---

## Table of Contents

- [Setup](#setup)
- [Frame Loop](#frame-loop)
- [Runtime Hooks](#runtime-hooks)
  - [useState](#usestate)
  - [useEffect](#useeffect)
  - [useInstance](#useinstance)
  - [useKey](#usekey)
  - [useContext / provideContext / createContext](#context)
- [Style API](#style-api)
- [Widgets](#widgets)
  - [window](#window)
  - [button](#button)
  - [checkbox](#checkbox)
  - [radioButton](#radiobutton)
  - [selectableLabel](#selectablelabel)
  - [comboBox](#combobox)
  - [slider](#slider)
  - [dragValue](#dragvalue)
  - [progressBar](#progressbar)
  - [toggle](#toggle)
  - [input](#input)
  - [label](#label)
  - [heading](#heading)
  - [separator](#separator)
  - [space](#space)
  - [row](#row)
  - [clickableLabel](#clickablelabel)
  - [collapsingHeader](#collapsingheader)
  - [popup](#popup)
  - [modal](#modal)
  - [demoWindow](#demowindow)
- [Building Custom Widgets](#building-custom-widgets)

---

## Setup

Require egooe from `ReplicatedStorage` and create a root node tied to a `ScreenGui`.

```lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local egooe = require(ReplicatedStorage.egooe)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local node = egooe.new(screenGui)
```

---

## Frame Loop

Call `egooe.start` once per frame (typically inside `RunService.Heartbeat` or `RunService.RenderStepped`) passing the root node and a render function.

```lua
local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function()
    egooe.start(node, function()
        -- call widgets here
        egooe.window("My Window", function()
            egooe.label("Hello, world!")
        end)
    end)
end)
```

All widget calls and state reads/writes must happen **inside** the `start` callback. Calling widgets outside of a frame is not supported.

---

## Runtime Hooks

Hooks must be called in the same order every frame (same rules as React hooks — no conditionals around them).

### useState

```lua
local value, setValue = egooe.useState(initialValue)
```

Persists a value across frames. `setValue` can take a plain value or an updater function.

```lua
local count, setCount = egooe.useState(0)

-- plain value
setCount(count + 1)

-- updater function (receives previous value)
setCount(function(prev)
    return prev + 1
end)
```

### useEffect

```lua
egooe.useEffect(callback, ...dependencies)
```

Runs `callback` once when it is first encountered, and again whenever any dependency changes. If `callback` returns a function, that function is called for cleanup before the next run or on destroy.

With no dependencies the callback only runs once (on mount):

```lua
egooe.useEffect(function()
    local connection = someEvent:Connect(handler)
    return function()
        connection:Disconnect()
    end
end)
```

With dependencies it re-runs when they change:

```lua
egooe.useEffect(function()
    print("theme changed to", theme)
end, theme)
```

### useInstance

```lua
local refs = egooe.useInstance(function(ref)
    -- create instances here (runs ONCE, never again)
    local frame = Instance.new("Frame")
    ref.myFrame = frame   -- capture named refs
    return frame          -- root instance (gets parented automatically)
end)
```

The returned `refs` table is the same object every frame. Use it to read or write instance properties in the render body after `useInstance`. The second return value from the creator is used as the container for child widgets.

### useKey

```lua
egooe.useKey(key)
```

Ties all subsequent state in this scope to `key`. Useful when rendering the same widget type in a loop so each iteration gets its own independent state.

```lua
for i, item in ipairs(items) do
    egooe.useKey(item.id)
    egooe.button(item.name)
end
```

### Context

```lua
local MyContext = egooe.createContext("MyContext")

-- parent widget
egooe.provideContext(MyContext, someValue)

-- descendant widget
local value = egooe.useContext(MyContext)
```

Passes values down the widget tree without threading them through every function argument.

---

## Style API

```lua
-- read current style
local style = egooe.useStyle()

-- override style (call before first frame, or to hot-swap)
egooe.setStyle({
    textColor = Color3.fromRGB(255, 255, 255),
    textSize = 14,
    -- ...
})
```

Style tokens available in the returned table include `textColor`, `textSize`, `textDisabledColor`, `itemHeight`, `buttonColor`, `buttonHoveredColor`, `buttonActiveColor`, `frameBgColor`, `frameBgHoveredColor`, `windowBgColor`, `titleBgActiveColor`, `borderColor`, `sliderGrabColor`, `checkMarkColor`, `separatorColor`, `scrollbarGrabColor`, and more.

---

## Widgets

### window

Opens a floating, draggable, resizable window panel. Children are rendered inside a scrollable content area.

**Signature**
```
window(options: string | WindowOptions, children: () -> ()) -> WindowHandle
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `title` | `string` | `""` | Title bar text |
| `closable` | `boolean` | `false` | Show × close button |
| `movable` | `boolean` | `true` | Allow dragging by title bar |
| `resizable` | `boolean` | `true` | Show resize grip (bottom-right) |
| `size` | `Vector2` | `(300, 400)` | Initial size in pixels |
| `position` | `Vector2` | `(60, 60)` | Initial position in pixels |

**Handle**

| Method | Returns | Description |
|---|---|---|
| `closed()` | `boolean` | `true` once when the × button was clicked |

**Example**
```lua
local windowOpen = true

RunService.Heartbeat:Connect(function()
    egooe.start(node, function()
        if not windowOpen then return end

        local w = egooe.window({
            title = "Settings",
            closable = true,
            movable = true,
            resizable = true,
            size = Vector2.new(300, 400),
            position = Vector2.new(40, 40),
        }, function()
            egooe.label("Window content goes here.")
        end)

        if w:closed() then
            windowOpen = false
        end
    end)
end)
```

---

### button

A clickable button.

**Signature**
```
button(text: string, options?: ButtonOptions) -> ButtonHandle
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `width` | `number \| UDim` | full width | Button width; number = pixels, UDim = scale/offset |
| `disabled` | `boolean` | `false` | Greyed out, click does nothing |

**Handle**

| Method | Returns | Description |
|---|---|---|
| `clicked()` | `boolean` | `true` once on the frame it was clicked |

**Example**
```lua
local clickCount, setClickCount = egooe.useState(0)

if egooe.button("Click me!"):clicked() then
    setClickCount(clickCount + 1)
end
egooe.label("Clicked " .. clickCount .. " time(s)")

-- fixed-width buttons side by side
egooe.row(function()
    egooe.button("OK", { width = 80 })
    egooe.button("Cancel", { width = 80, disabled = true })
end)
```

---

### checkbox

A toggleable checkbox with a label.

**Signature**
```
checkbox(text: string, options?: CheckboxOptions) -> CheckboxHandle
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `checked` | `boolean` | internal state | Controlled checked state |
| `disabled` | `boolean` | `false` | Greyed out, click does nothing |

**Handle**

| Method | Returns | Description |
|---|---|---|
| `checked()` | `boolean` | Current checked state |
| `clicked()` | `boolean` | `true` once when toggled |

**Example**
```lua
local enabled, setEnabled = egooe.useState(false)

if egooe.checkbox("Enable shadows", { checked = enabled }):clicked() then
    setEnabled(not enabled)
end

-- uncontrolled — manages its own state internally
egooe.checkbox("Standalone toggle")
```

---

### radioButton

A radio button for single-choice selection. You are responsible for tracking which option is selected.

**Signature**
```
radioButton(text: string, options?: RadioButtonOptions) -> RadioButtonHandle
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `selected` | `boolean` | `false` | Whether this button is the active selection |
| `disabled` | `boolean` | `false` | Greyed out, click does nothing |

**Handle**

| Method | Returns | Description |
|---|---|---|
| `selected()` | `boolean` | Whether this button is selected |
| `clicked()` | `boolean` | `true` once when this button is clicked |

**Example**
```lua
local choices = { "Low", "Medium", "High" }
local quality, setQuality = egooe.useState("Medium")

for _, option in ipairs(choices) do
    local captured = option
    if egooe.radioButton(option, { selected = quality == option }):clicked() then
        setQuality(captured)
    end
end
egooe.label("Quality: " .. quality)
```

---

### selectableLabel

A text label that highlights when selected. Useful for tab bars or list selections.

**Signature**
```
selectableLabel(text: string, options?: SelectableLabelOptions) -> SelectableLabelHandle
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `selected` | `boolean` | `false` | Highlighted/active state |
| `disabled` | `boolean` | `false` | Greyed out, click does nothing |

**Handle**

| Method | Returns | Description |
|---|---|---|
| `selected()` | `boolean` | Current selected state |
| `clicked()` | `boolean` | `true` once when clicked |

**Example**
```lua
local tabs = { "General", "Advanced", "About" }
local activeTab, setActiveTab = egooe.useState("General")

egooe.row(function()
    for _, tab in ipairs(tabs) do
        local captured = tab
        if egooe.selectableLabel(tab, { selected = activeTab == tab }):clicked() then
            setActiveTab(captured)
        end
    end
end)
egooe.label("Active tab: " .. activeTab)
```

---

### comboBox

A dropdown selector for picking one item from a list.

**Signature**
```
comboBox(options: ComboBoxOptions) -> ComboBoxHandle
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `items` | `{string}` | `{}` | List of selectable strings |
| `selected` | `string` | first item | Initial selection |

**Handle**

| Method | Returns | Description |
|---|---|---|
| `value()` | `string` | Currently selected item |
| `changed()` | `boolean` | `true` once on the frame selection changed |

**Example**
```lua
local resolution, setResolution = egooe.useState("1080p")

local combo = egooe.comboBox({
    items = { "720p", "1080p", "1440p", "4K" },
    selected = "1080p",
})
if combo:changed() then
    setResolution(combo:value())
end
egooe.label("Resolution: " .. resolution)
```

---

### slider

A horizontal drag slider that returns a numeric value each frame.

**Signature**
```
slider(options?: SliderOptions | number) -> number
```

Passing a plain number is shorthand for `{ max = number }`.

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `min` | `number` | `0` | Minimum value |
| `max` | `number` | `1` | Maximum value |
| `initial` | `number` | `min` | Starting value |
| `label` | `string` | — | Prefix shown in the value overlay |

**Returns** the current numeric value every frame.

**Example**
```lua
local volume, setVolume = egooe.useState(0.5)

local v = egooe.slider({ min = 0, max = 1, initial = volume, label = "Volume" })
setVolume(v)
egooe.label(string.format("%.0f%%", volume * 100))
```

---

### dragValue

A number field you drag left/right to change the value. More compact than a slider when space is tight.

**Signature**
```
dragValue(options?: DragValueOptions) -> number
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `min` | `number` | `0` | Minimum value |
| `max` | `number` | `100` | Maximum value |
| `initial` | `number` | `min` | Starting value |
| `step` | `number` | `1` | Amount changed per 4 pixels of drag |
| `label` | `string` | — | Prefix shown in the field |

**Returns** the current numeric value every frame.

**Example**
```lua
local speed, setSpeed = egooe.useState(10)

local v = egooe.dragValue({ min = 0, max = 200, initial = speed, step = 1, label = "Speed" })
setSpeed(v)
```

---

### progressBar

A read-only filled bar showing a 0–1 progress value.

**Signature**
```
progressBar(options: ProgressBarOptions) -> ()
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `value` | `number` | `0` | Fill amount, clamped to [0, 1] |
| `label` | `string` | `"XX%"` | Override the centered text label |

**Example**
```lua
local progress, setProgress = egooe.useState(0)

egooe.progressBar({ value = progress })
egooe.label(math.floor(progress * 100) .. "% complete")

egooe.row(function()
    if egooe.button("−10%", { width = 60 }):clicked() then
        setProgress(math.max(0, progress - 0.1))
    end
    if egooe.button("+10%", { width = 60 }):clicked() then
        setProgress(math.min(1, progress + 0.1))
    end
end)
```

---

### toggle

An on/off switch with a sliding handle and a label.

**Signature**
```
toggle(text: string, options?: ToggleOptions) -> ToggleHandle
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `on` | `boolean` | internal state | Controlled on/off state |
| `disabled` | `boolean` | `false` | Greyed out, click does nothing |

**Handle**

| Method | Returns | Description |
|---|---|---|
| `on()` | `boolean` | Current on/off state |
| `clicked()` | `boolean` | `true` once when toggled |

**Example**
```lua
local darkMode, setDarkMode = egooe.useState(false)

if egooe.toggle("Dark mode", { on = darkMode }):clicked() then
    setDarkMode(not darkMode)
end

egooe.toggle("Unavailable feature", { on = false, disabled = true })
```

---

### input

A single-line text box.

**Signature**
```
input(options?: InputOptions) -> InputHandle
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `text` | `string` | — | Controlled text value |
| `placeholder` | `string` | `""` | Placeholder text when empty |
| `label` | `string` | — | Label shown to the left of the box (80px wide) |

**Handle**

| Method | Returns | Description |
|---|---|---|
| `value()` | `string` | Current text content |
| `changed()` | `boolean` | `true` once when text changed this frame |
| `submitted()` | `boolean` | `true` once when Enter was pressed |

**Example**
```lua
local text, setText = egooe.useState("")
local submitted, setSubmitted = egooe.useState("")

local handle = egooe.input({ placeholder = "Search...", label = "Query" })
if handle:changed() then
    setText(handle:value())
end
if handle:submitted() then
    setSubmitted("Searched: " .. handle:value())
end
if text ~= "" then
    egooe.label("Live: " .. text)
end
if submitted ~= "" then
    egooe.label(submitted)
end
```

---

### label

Displays a line of static or dynamic text.

**Signature**
```
label(text: string, options?: LabelOptions) -> ()
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `color` | `Color3` | theme text color | Text color |
| `textSize` | `number` | theme text size | Font size |
| `wrapped` | `boolean` | `false` | Wrap across multiple lines (auto-height) |

**Example**
```lua
egooe.label("Normal text")
egooe.label("Warning!", { color = Color3.fromRGB(255, 180, 0) })
egooe.label("A very long sentence that needs to wrap at the edge of the window.", { wrapped = true })
```

---

### heading

Bold section heading text, slightly larger than normal labels.

**Signature**
```
heading(text: string, options?: HeadingOptions) -> ()
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `textSize` | `number` | theme size + 2 | Font size override |
| `font` | `Enum.Font` | `GothamBold` | Font override |

**Example**
```lua
egooe.heading("Controls")
egooe.separator()
egooe.label("Press W to move forward.")
```

---

### separator

A 1-pixel horizontal divider line.

**Signature**
```
separator() -> ()
```

**Example**
```lua
egooe.heading("Section A")
egooe.separator()
egooe.label("First item")
egooe.separator()
egooe.label("Second item")
```

---

### space

Inserts blank vertical space.

**Signature**
```
space(size?: number) -> ()
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `size` | `number` | `8` | Height of the gap in pixels |

**Example**
```lua
egooe.label("Top section")
egooe.space(16)
egooe.label("Bottom section, further away")
```

---

### row

Lays children out horizontally instead of vertically.

**Signature**
```
row(options?: RowOptions | () -> (), children?: () -> ()) -> ()
```

Passing the children function directly (skipping options) is the most common usage.

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `padding` | `number \| UDim` | `8` | Horizontal gap between children |
| `alignment` | `Enum.HorizontalAlignment` | `Left` | Horizontal alignment of children |
| `verticalAlignment` | `Enum.VerticalAlignment` | `Center` | Vertical alignment of children |

**Example**
```lua
-- simple row
egooe.row(function()
    egooe.button("Save", { width = 80 })
    egooe.button("Discard", { width = 80 })
end)

-- row with custom padding and alignment
egooe.row({ padding = 4, alignment = Enum.HorizontalAlignment.Center }, function()
    egooe.button("A", { width = 60 })
    egooe.button("B", { width = 60 })
    egooe.button("C", { width = 60 })
end)
```

---

### clickableLabel

A hyperlink-style text label that underlines on hover and fires a click event.

**Signature**
```
clickableLabel(text: string, options?: ClickableLabelOptions) -> ClickableLabelHandle
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `color` | `Color3` | theme button color | Text / link color |
| `textSize` | `number` | theme text size | Font size |

**Handle**

| Method | Returns | Description |
|---|---|---|
| `clicked()` | `boolean` | `true` once when clicked |

**Example**
```lua
if egooe.clickableLabel("Open documentation →"):clicked() then
    -- handle click
end

if egooe.clickableLabel("Delete account", { color = Color3.fromRGB(220, 60, 60) }):clicked() then
    -- handle click
end
```

---

### collapsingHeader

A toggleable section header that shows/hides its children.

**Signature**
```
collapsingHeader(text: string, children: () -> ()) -> CollapsingHeaderHandle
```

**Handle**

| Method | Returns | Description |
|---|---|---|
| `open()` | `boolean` | Whether the section is currently expanded |

**Example**
```lua
egooe.collapsingHeader("Advanced Settings", function()
    egooe.label("These settings are for experts only.")
    egooe.slider({ min = 0, max = 10, label = "Debug Level" })
end)

-- check open state
local h = egooe.collapsingHeader("Stats", function()
    egooe.label("FPS: 60")
end)
if h:open() then
    -- section is expanded
end
```

---

### popup

A floating panel anchored to where it is called in the layout. Rendered into the root `ScreenGui` so it appears above all other widgets.

**Signature**
```
popup(options: PopupOptions, children: () -> ()) -> ()
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `open` | `boolean` | `false` | Whether the popup is visible |
| `position` | `Vector2` | below anchor | Explicit screen position override |

**Example**
```lua
local showPopup, setShowPopup = egooe.useState(false)

if egooe.button(showPopup and "Close" or "Options"):clicked() then
    setShowPopup(not showPopup)
end

egooe.popup({ open = showPopup }, function()
    egooe.label("Popup menu")
    egooe.separator()
    if egooe.clickableLabel("Action A"):clicked() then
        setShowPopup(false)
    end
    if egooe.clickableLabel("Action B"):clicked() then
        setShowPopup(false)
    end
end)
```

---

### modal

A blocking dialog that overlays the entire screen. Content is rendered centered with a dimmed overlay behind it.

**Signature**
```
modal(options: ModalOptions, children: () -> ()) -> ModalHandle
```

**Options**

| Field | Type | Default | Description |
|---|---|---|---|
| `title` | `string` | `""` | Dialog title bar text |
| `open` | `boolean` | `true` | Whether the modal is visible |
| `closable` | `boolean` | `false` | Show × button in the title bar |

**Handle**

| Method | Returns | Description |
|---|---|---|
| `closed()` | `boolean` | `true` once when × was clicked |

**Example**
```lua
local showModal, setShowModal = egooe.useState(false)
local result, setResult = egooe.useState("")

if egooe.button("Open dialog"):clicked() then
    setShowModal(true)
    setResult("")
end

if result ~= "" then
    egooe.label("You chose: " .. result)
end

local m = egooe.modal({ title = "Confirm", open = showModal, closable = true }, function()
    egooe.label("Are you sure you want to continue?")
    egooe.space(6)
    egooe.row(function()
        if egooe.button("Yes", { width = 80 }):clicked() then
            setShowModal(false)
            setResult("Yes")
        end
        if egooe.button("No", { width = 80 }):clicked() then
            setShowModal(false)
            setResult("No")
        end
    end)
end)

if m:closed() then
    setShowModal(false)
end
```

---

### demoWindow

Opens the built-in widget gallery that showcases every available widget with interactive examples.

**Signature**
```
demoWindow() -> ()
```

**Example**
```lua
RunService.Heartbeat:Connect(function()
    egooe.start(node, function()
        egooe.demoWindow()
    end)
end)
```

---

## Building Custom Widgets

Use `egooe.widget` to create reusable widget functions. The wrapped function receives a new scope automatically, allowing it to call hooks.

```lua
local egooe = require(ReplicatedStorage.egooe)
local Runtime = egooe   -- same table; all hooks are on it

-- A labeled number display that flashes red when value exceeds a threshold
local alertValue = egooe.widget(function(options)
    options = options or {}
    local value = options.value or 0
    local threshold = options.threshold or 100

    local refs = egooe.useInstance(function(ref)
        local style = egooe.useStyle()
        local frame = Instance.new("Frame")
        frame.BackgroundTransparency = 1
        frame.Size = UDim2.new(1, 0, 0, style.itemHeight)

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Code
        lbl.TextSize = style.textSize
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.Parent = frame

        ref.lbl = lbl
        return frame
    end)

    local style = egooe.useStyle()
    refs.lbl.Text = (options.label or "Value") .. ": " .. tostring(value)
    refs.lbl.TextColor3 = value > threshold
        and Color3.fromRGB(255, 80, 80)
        or style.textColor
end)

-- Usage inside a start loop:
alertValue({ label = "Health", value = currentHealth, threshold = 25 })
```

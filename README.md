# iris-plasma (improved-garbanzo)

An immediate-mode UI framework for Roblox with **Iris visual style** and a **Plasma-compatible API**.

## Features

- **Plasma-compatible API** – same `useInstance`, `useState`, `useEffect`, `useKey`, `scope`, `widget`, `window`, etc.
- **Iris dark theme** – Dear ImGui inspired color palette (dark blues, accent blues, transparent frame backgrounds)
- **No automatic sizing** – all widgets have explicit, fixed pixel sizes (unlike Plasma)
- **Modern Roblox UI** – `UICorner`, `UIStroke`, `UIListLayout`, `ScrollingFrame` used throughout
- **Interactive demo gallery** – `demoWindow()` now has inline gallery tab plus dedicated side-window demos
- **Table widgets** – immediate-mode `table`, `tableRow`, and `tableCell` with nested widgets, borders, and striping

## Installation

Install with [Wally](https://wally.run/) by adding to your `wally.toml`:

```toml
EgooE = "capedbojji/iris-plasma@0.1.1"
```

Or sync with [Rojo](https://rojo.space/) using `default.project.json`.

## Demo Window

The quickest way to see all widgets in action — just call `demoWindow()` inside your `start` loop:

```lua
local EgooE = require(path.to.EgooE)
local node = EgooE.new(playerGui.ScreenGui)

RunService.Heartbeat:Connect(function()
    EgooE.start(node, function()
        EgooE.demoWindow()
    end)
end)
```

This opens a gallery window with 2 tabs:
- `Gallery` for broad inline widget examples
- `Demos` for dedicated playgrounds that open side windows for `window`, `childWindow`, `table`, `popup`, `modal`, and layout tests

## Quick Start

```lua
local EgooE = require(path.to.EgooE)

local node = EgooE.new(playerGui.ScreenGui)

RunService.Heartbeat:Connect(function()
    EgooE.start(node, function()
        EgooE.window("Demo", function()
            EgooE.heading("Hello, Iris!")
            EgooE.separator()
            EgooE.label("This is a label.")

            if EgooE.button("Click me"):clicked() then
                print("Button clicked!")
            end

            local checked = EgooE.checkbox("Toggle me"):checked()
            local value   = EgooE.slider({ min = 0, max = 100, label = "Speed" })

            local handle = EgooE.input({ placeholder = "Type something..." })
            if handle:changed() then
                print("Input:", handle:value())
            end
        end)
    end)
end)
```

## Widgets

| Widget        | Description                                      |
|---------------|--------------------------------------------------|
| `window`      | Draggable, resizable, scrollable window          |
| `button`      | Iris-styled click button                         |
| `checkbox`    | Controlled/uncontrolled checkbox                 |
| `slider`      | Horizontal range slider                          |
| `input`       | Text input box                                   |
| `label`       | Single-line text display                         |
| `heading`     | Bold section heading                             |
| `separator`   | Horizontal divider line                          |
| `row`         | Horizontal layout container                      |
| `childWindow` | Inline scrollable panel with clickable header    |
| `table`       | Immediate-mode table container                   |
| `tableRow`    | Table row builder                                |
| `tableCell`   | Table cell builder for nested widgets            |
| `space`       | Blank pixel spacer                               |
| `portal`      | Mount children in an arbitrary Instance          |
| `demoWindow`  | Live showcase of every widget (zero setup)       |

## Style

The Iris dark theme is applied by default. Override any values per-scope with `setStyle`:

```lua
EgooE.setStyle({
    buttonColor = Color3.fromRGB(200, 60, 60),
})
EgooE.button("Danger")
```

## API

Identical to [Plasma](https://github.com/matter-ecs/plasma):

```lua
EgooE.new(rootInstance)
EgooE.start(node, fn)
EgooE.beginFrame(node, fn) / continueFrame(handle, fn) / finishFrame(node)
EgooE.scope(fn)
EgooE.widget(fn)
EgooE.useState(initial)
EgooE.useInstance(creator)
EgooE.useEffect(callback, ...deps)
EgooE.useKey(key)
EgooE.createContext(name) / provideContext(ctx, val) / useContext(ctx)
EgooE.useStyle() / setStyle(fragment)
```

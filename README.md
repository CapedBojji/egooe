# iris-plasma (improved-garbanzo)

An immediate-mode UI framework for Roblox with **Iris visual style** and a **Plasma-compatible API**.

## Features

- **Plasma-compatible API** – same `useInstance`, `useState`, `useEffect`, `useKey`, `scope`, `widget`, `window`, etc.
- **Iris dark theme** – Dear ImGui inspired color palette (dark blues, accent blues, transparent frame backgrounds)
- **No automatic sizing** – all widgets have explicit, fixed pixel sizes (unlike Plasma)
- **Modern Roblox UI** – `UICorner`, `UIStroke`, `UIListLayout`, `ScrollingFrame` used throughout

## Installation

Install with [Wally](https://wally.run/) by adding to your `wally.toml`:

```toml
IrisPlasma = "capedbojji/iris-plasma@0.1.0"
```

Or sync with [Rojo](https://rojo.space/) using `default.project.json`.

## Demo Window

The quickest way to see all widgets in action — just call `demoWindow()` inside your `start` loop:

```lua
local IrisPlasma = require(path.to.IrisPlasma)
local node = IrisPlasma.new(playerGui.ScreenGui)

RunService.Heartbeat:Connect(function()
    IrisPlasma.start(node, function()
        IrisPlasma.demoWindow()
    end)
end)
```

This opens a 340×580 window covering every widget category:
**Text** (label, heading, wrapped text) · **Buttons** (normal, sized, disabled) ·
**Checkboxes** (controlled, uncontrolled, disabled) · **Sliders** · **Text Input** ·
**Row layouts** · **Separators** · **Conditional visibility toggle**

## Quick Start

```lua
local IrisPlasma = require(path.to.IrisPlasma)

local node = IrisPlasma.new(playerGui.ScreenGui)

RunService.Heartbeat:Connect(function()
    IrisPlasma.start(node, function()
        IrisPlasma.window("Demo", function()
            IrisPlasma.heading("Hello, Iris!")
            IrisPlasma.separator()
            IrisPlasma.label("This is a label.")

            if IrisPlasma.button("Click me"):clicked() then
                print("Button clicked!")
            end

            local checked = IrisPlasma.checkbox("Toggle me"):checked()
            local value   = IrisPlasma.slider({ min = 0, max = 100, label = "Speed" })

            local handle = IrisPlasma.input({ placeholder = "Type something..." })
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
| `space`       | Blank pixel spacer                               |
| `portal`      | Mount children in an arbitrary Instance          |
| `demoWindow`  | Live showcase of every widget (zero setup)       |

## Style

The Iris dark theme is applied by default. Override any values per-scope with `setStyle`:

```lua
IrisPlasma.setStyle({
    buttonColor = Color3.fromRGB(200, 60, 60),
})
IrisPlasma.button("Danger")
```

## API

Identical to [Plasma](https://github.com/matter-ecs/plasma):

```lua
IrisPlasma.new(rootInstance)
IrisPlasma.start(node, fn)
IrisPlasma.beginFrame(node, fn) / continueFrame(handle, fn) / finishFrame(node)
IrisPlasma.scope(fn)
IrisPlasma.widget(fn)
IrisPlasma.useState(initial)
IrisPlasma.useInstance(creator)
IrisPlasma.useEffect(callback, ...deps)
IrisPlasma.useKey(key)
IrisPlasma.createContext(name) / provideContext(ctx, val) / useContext(ctx)
IrisPlasma.useStyle() / setStyle(fragment)
```


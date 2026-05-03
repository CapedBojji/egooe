--[=[
	@within IrisPlasma
	@function demoWindow
	@tag widgets

	Opens a demo window that showcases every available widget.
	Call this once per frame inside a `start` loop to display the demo.

	```lua
	IrisPlasma.start(node, function()
		IrisPlasma.demoWindow()
	end)
	```
]=]

local Runtime = require(script.Parent.Parent.Runtime)

-- Widget modules required directly to avoid a circular dependency with init.lua
local window   = require(script.Parent.window)
local button   = require(script.Parent.button)
local checkbox = require(script.Parent.checkbox)
local slider   = require(script.Parent.slider)
local input    = require(script.Parent.input)
local label    = require(script.Parent.label)
local heading  = require(script.Parent.heading)
local separator = require(script.Parent.separator)
local row      = require(script.Parent.row)
local space    = require(script.Parent.space)

return Runtime.widget(function()
	-- ── per-frame mutable state ────────────────────────────────────────────────

	-- Buttons
	local clickCount, setClickCount = Runtime.useState(0)

	-- Checkboxes
	local cb1, setCb1 = Runtime.useState(false)
	local cb2, setCb2 = Runtime.useState(true)

	-- Sliders
	local sliderVal1, setSliderVal1 = Runtime.useState(0)
	local sliderVal2, setSliderVal2 = Runtime.useState(50)

	-- Input
	local inputText, setInputText = Runtime.useState("")
	local submitLog, setSubmitLog = Runtime.useState("")

	-- Visibility toggle
	local showExtra, setShowExtra = Runtime.useState(false)

	-- ── main demo window ───────────────────────────────────────────────────────

	window({
		title = "IrisPlasma Demo",
		closable = false,
		movable = true,
		resizable = true,
		size = Vector2.new(340, 580),
		position = Vector2.new(30, 30),
	}, function()

		-- ── Heading & Label ───────────────────────────────────────────────────
		heading("Text Widgets")
		separator()

		label("Plain label – white, Code font")
		label("Muted label", { color = Color3.fromRGB(128, 128, 128) })
		label("Larger label", { textSize = 17 })
		label(
			"A longer piece of text that wraps inside the window so you can see how TextWrapped works here.",
			{ wrapped = true }
		)

		space(6)

		-- ── Buttons ───────────────────────────────────────────────────────────
		heading("Buttons")
		separator()

		if button("Click me"):clicked() then
			setClickCount(clickCount + 1)
		end

		label("Clicked " .. tostring(clickCount) .. " time(s)")

		space(4)

		row(function()
			button("Small A", { width = 90 })
			button("Small B", { width = 90 })
			button("Disabled", { width = 90, disabled = true })
		end)

		space(6)

		-- ── Checkboxes ────────────────────────────────────────────────────────
		heading("Checkboxes")
		separator()

		if checkbox("Controlled checkbox", { checked = cb1 }):clicked() then
			setCb1(not cb1)
		end

		if checkbox("Controlled checkbox (default on)", { checked = cb2 }):clicked() then
			setCb2(not cb2)
		end

		checkbox("Uncontrolled checkbox")

		checkbox("Disabled checkbox", { checked = true, disabled = true })

		space(6)

		-- ── Sliders ───────────────────────────────────────────────────────────
		heading("Sliders")
		separator()

		local v1 = slider({ min = 0, max = 1, initial = sliderVal1, label = "Alpha" })
		setSliderVal1(v1)

		local v2 = slider({ min = 0, max = 100, initial = sliderVal2, label = "Speed" })
		setSliderVal2(v2)

		slider({ min = -10, max = 10, initial = 0, label = "Offset" })

		space(6)

		-- ── Text Input ────────────────────────────────────────────────────────
		heading("Input")
		separator()

		local handle = input({ placeholder = "Type something…", label = "Text" })

		if handle:changed() then
			setInputText(handle:value())
		end

		if handle:submitted() then
			setSubmitLog("Submitted: " .. handle:value())
		end

		if inputText ~= "" then
			label("Live: " .. inputText)
		end

		if submitLog ~= "" then
			label(submitLog, { color = Color3.fromRGB(100, 220, 100) })
		end

		space(6)

		-- ── Row / Layout ──────────────────────────────────────────────────────
		heading("Row Layout")
		separator()

		row(function()
			label("Left")
			label("Center")
			label("Right")
		end)

		row({ alignment = Enum.HorizontalAlignment.Center }, function()
			button("A", { width = 60 })
			button("B", { width = 60 })
			button("C", { width = 60 })
		end)

		space(6)

		-- ── Separator standalone demo ─────────────────────────────────────────
		heading("Separator")
		separator()
		label("Above")
		separator()
		label("Below")

		space(6)

		-- ── Conditional / Toggle extra panel ─────────────────────────────────
		heading("Widget Visibility Toggle")
		separator()

		if button(showExtra and "Hide extra section ▲" or "Show extra section ▼"):clicked() then
			setShowExtra(not showExtra)
		end

		if showExtra then
			space(4)
			heading("Extra Section", { textSize = 13 })
			label("This section appeared because you clicked the button above.")
			label("It disappears when you click again — no manual cleanup needed.")
		end

	end)
end)

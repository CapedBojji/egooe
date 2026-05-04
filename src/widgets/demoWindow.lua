--[=[
	@within EgooE
	@function demoWindow
	@tag widgets

	Opens a demo window that showcases every available widget.
	Call this once per frame inside a `start` loop to display the demo.

	```lua
	EgooE.start(node, function()
		EgooE.demoWindow()
	end)
	```
]=]

local Runtime = require(script.Parent.Parent.Runtime)

local window          = require(script.Parent.window)
local button          = require(script.Parent.button)
local checkbox        = require(script.Parent.checkbox)
local slider          = require(script.Parent.slider)
local input           = require(script.Parent.input)
local label           = require(script.Parent.label)
local heading         = require(script.Parent.heading)
local separator       = require(script.Parent.separator)
local row             = require(script.Parent.row)
local space           = require(script.Parent.space)
local radioButton     = require(script.Parent.radioButton)
local selectableLabel = require(script.Parent.selectableLabel)
local comboBox        = require(script.Parent.comboBox)
local dragValue       = require(script.Parent.dragValue)
local progressBar     = require(script.Parent.progressBar)
local collapsingHeader = require(script.Parent.collapsingHeader)
local toggle          = require(script.Parent.toggle)
local clickableLabel  = require(script.Parent.clickableLabel)
local modal           = require(script.Parent.modal)
local popup           = require(script.Parent.popup)

return Runtime.widget(function()

	-- ── state ──────────────────────────────────────────────────────────────────

	local clickCount, setClickCount = Runtime.useState(0)

	local cb1, setCb1 = Runtime.useState(false)
	local cb2, setCb2 = Runtime.useState(true)

	local sliderVal1, setSliderVal1 = Runtime.useState(0)
	local sliderVal2, setSliderVal2 = Runtime.useState(50)

	local inputText, setInputText = Runtime.useState("")
	local submitLog, setSubmitLog = Runtime.useState("")

	local showExtra, setShowExtra = Runtime.useState(false)

	-- Radio
	local radioChoice, setRadioChoice = Runtime.useState("First")

	-- SelectableLabel
	local selectedTab, setSelectedTab = Runtime.useState(1)

	-- ComboBox
	local comboSelected, setComboSelected = Runtime.useState("First")

	-- DragValue
	local dragVal, setDragVal = Runtime.useState(112)

	-- Progress
	local progressVal, setProgressVal = Runtime.useState(0.31)

	-- Toggle
	local toggleOn, setToggleOn = Runtime.useState(false)

	-- Modal
	local showModal, setShowModal = Runtime.useState(false)
	local modalResult, setModalResult = Runtime.useState("")

	-- Popup
	local showPopup, setShowPopup = Runtime.useState(false)

	-- ── main demo window ───────────────────────────────────────────────────────

	window({
		title = "Widget Gallery",
		closable = false,
		movable = true,
		resizable = true,
		size = Vector2.new(380, 640),
		position = Vector2.new(30, 30),
	}, function()

		-- ── Text ─────────────────────────────────────────────────────────────
		heading("Label")
		separator()
		label("Welcome to the widget gallery!")
		label("Muted text", { color = Color3.fromRGB(128, 128, 128) })
		label("This is a longer piece of text that will wrap across multiple lines when it reaches the edge of the window.", { wrapped = true })

		space(6)

		-- ── Button ───────────────────────────────────────────────────────────
		heading("Button")
		separator()

		if button("Click me!"):clicked() then
			setClickCount(clickCount + 1)
		end
		label("Clicked " .. tostring(clickCount) .. " time(s)")

		space(4)
		row(function()
			button("Small A", { width = 90 })
			button("Disabled", { width = 90, disabled = true })
		end)

		space(6)

		-- ── ClickableLabel ────────────────────────────────────────────────────
		heading("ClickableLabel")
		separator()

		if clickableLabel("View source on GitHub →"):clicked() then
			setClickCount(clickCount + 1)
		end

		space(6)

		-- ── Checkbox ─────────────────────────────────────────────────────────
		heading("Checkbox")
		separator()

		if checkbox("Click to toggle", { checked = cb1 }):clicked() then
			setCb1(not cb1)
		end
		if checkbox("Pre-checked", { checked = cb2 }):clicked() then
			setCb2(not cb2)
		end
		checkbox("Disabled", { checked = true, disabled = true })

		space(6)

		-- ── RadioButton ───────────────────────────────────────────────────────
		heading("RadioButton")
		separator()

		for _, opt in ipairs({ "First", "Second", "Third" }) do
			local capturedOpt = opt
			if radioButton(opt, { selected = radioChoice == opt }):clicked() then
				setRadioChoice(capturedOpt)
			end
		end
		label("Selected: " .. radioChoice)

		space(6)

		-- ── SelectableLabel ───────────────────────────────────────────────────
		heading("SelectableLabel")
		separator()

		row(function()
			for i, name in ipairs({ "First", "Second", "Third" }) do
				local capturedI = i
				if selectableLabel(name, { selected = selectedTab == i }):clicked() then
					setSelectedTab(capturedI)
				end
			end
		end)
		label("Tab: " .. tostring(selectedTab))

		space(6)

		-- ── ComboBox ──────────────────────────────────────────────────────────
		heading("ComboBox")
		separator()

		local combo = comboBox({ items = { "First", "Second", "Third" } })
		if combo:changed() then
			setComboSelected(combo:value())
		end
		label("Pick: " .. comboSelected)

		space(6)

		-- ── Slider ────────────────────────────────────────────────────────────
		heading("Slider")
		separator()

		local v1 = slider({ min = 0, max = 1, initial = sliderVal1, label = "Alpha" })
		setSliderVal1(v1)

		local v2 = slider({ min = 0, max = 100, initial = sliderVal2, label = "Speed" })
		setSliderVal2(v2)

		space(6)

		-- ── DragValue ─────────────────────────────────────────────────────────
		heading("DragValue")
		separator()

		local dv = dragValue({ min = -200, max = 200, initial = dragVal, step = 1, label = "Value" })
		setDragVal(dv)

		space(6)

		-- ── ProgressBar ───────────────────────────────────────────────────────
		heading("ProgressBar")
		separator()

		progressBar({ value = progressVal })
		label(math.floor(progressVal * 100) .. "%")

		row(function()
			if button("−10%", { width = 60 }):clicked() then
				setProgressVal(math.max(0, progressVal - 0.1))
			end
			if button("+10%", { width = 60 }):clicked() then
				setProgressVal(math.min(1, progressVal + 0.1))
			end
		end)

		space(6)

		-- ── Toggle ────────────────────────────────────────────────────────────
		heading("Toggle (Custom Widget)")
		separator()

		if toggle("Enable feature", { on = toggleOn }):clicked() then
			setToggleOn(not toggleOn)
		end
		toggle("Disabled toggle", { on = true, disabled = true })

		space(6)

		-- ── Input ─────────────────────────────────────────────────────────────
		heading("TextEdit")
		separator()

		local handle = input({ placeholder = "Write something here", label = "Text" })
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

		-- ── Separator ─────────────────────────────────────────────────────────
		heading("Separator")
		separator()
		label("Above")
		separator()
		label("Below")

		space(6)

		-- ── CollapsingHeader ──────────────────────────────────────────────────
		heading("CollapsingHeader")
		separator()

		collapsingHeader("Click to see what is hidden!", function()
			label("You found the hidden content!")
			label("Sliders work inside collapsing headers too.")
			slider({ min = 0, max = 10, label = "Inner" })
		end)

		space(6)

		-- ── Popup ─────────────────────────────────────────────────────────────
		heading("Popup")
		separator()

		if button(showPopup and "Close popup" or "Open popup"):clicked() then
			setShowPopup(not showPopup)
		end

		popup({ open = showPopup }, function()
			label("Popup menu")
			separator()
			if clickableLabel("Option A"):clicked() then
				setShowPopup(false)
			end
			if clickableLabel("Option B"):clicked() then
				setShowPopup(false)
			end
			if clickableLabel("Option C"):clicked() then
				setShowPopup(false)
			end
		end)

		space(6)

		-- ── Modal ─────────────────────────────────────────────────────────────
		heading("Modal")
		separator()

		if button("Open modal"):clicked() then
			setShowModal(true)
			setModalResult("")
		end

		if modalResult ~= "" then
			label(modalResult, { color = Color3.fromRGB(100, 220, 100) })
		end

		local m = modal({ title = "Confirm action", open = showModal, closable = true }, function()
			label("Are you sure you want to proceed?")
			label("This action cannot be undone.", { color = Color3.fromRGB(200, 100, 100) })
			space(4)
			row(function()
				if button("Confirm", { width = 100 }):clicked() then
					setShowModal(false)
					setModalResult("Confirmed!")
				end
				if button("Cancel", { width = 100 }):clicked() then
					setShowModal(false)
					setModalResult("Cancelled.")
				end
			end)
		end)

		if m:closed() then
			setShowModal(false)
		end

	end)
end)

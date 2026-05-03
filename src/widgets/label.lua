--[=[
	@within IrisPlasma
	@function label
	@tag widgets
	@param text string -- The text to display
	@param options {textSize: number, color: Color3, wrapped: boolean}

	Displays a line of text. Uses Iris dark theme styling.

	```lua
	label("Hello, world!")
	```
]=]

local Runtime = require(script.Parent.Parent.Runtime)
local create = require(script.Parent.Parent.create)
local Style = require(script.Parent.Parent.Style)

return Runtime.widget(function(text, options)
	options = options or {}

	local refs = Runtime.useInstance(function(ref)
		local style = Style.get()

		return create("TextLabel", {
			[ref] = "label",
			BackgroundTransparency = 1,
			Font = Enum.Font.Code,
			TextColor3 = style.textColor,
			TextSize = style.textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			RichText = false,
			Size = UDim2.new(1, 0, 0, style.itemHeight),
		})
	end)

	local label = refs.label
	label.Text = text
	label.TextSize = options.textSize or Style.get().textSize
	label.TextColor3 = options.color or Style.get().textColor
	label.TextWrapped = options.wrapped or false
	if options.wrapped then
		label.TextTruncate = Enum.TextTruncate.None
	end
end)

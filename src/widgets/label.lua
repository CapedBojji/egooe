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

	local style = Style.get()
	local label = refs.label
	label.Text = text
	label.TextSize = options.textSize or style.textSize
	label.TextColor3 = options.color or style.textColor

	if options.wrapped then
		label.TextWrapped = true
		label.TextTruncate = Enum.TextTruncate.None
		label.AutomaticSize = Enum.AutomaticSize.Y
		label.Size = UDim2.new(1, 0, 0, 0)
	else
		label.TextWrapped = false
		label.TextTruncate = Enum.TextTruncate.AtEnd
		label.AutomaticSize = Enum.AutomaticSize.None
		label.Size = UDim2.new(1, 0, 0, style.itemHeight)
	end
end)

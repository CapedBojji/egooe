--[=[
	@within IrisPlasma
	@function row
	@tag widgets
	@param options {padding: number | UDim, alignment: HorizontalAlignment, verticalAlignment: VerticalAlignment}
	@param children () -> () -- Children

	Lays out children horizontally in a row. Children retain their own sizes.

	```lua
	row(function()
		button("OK")
		button("Cancel")
	end)
	```
]=]

local Runtime = require(script.Parent.Parent.Runtime)
local Style = require(script.Parent.Parent.Style)
local create = require(script.Parent.Parent.create)

return Runtime.widget(function(options, fn)
	if type(options) == "function" and fn == nil then
		fn = options
		options = {}
	end

	options = options or {}

	local padding
	if options.padding then
		if type(options.padding) == "number" then
			padding = UDim.new(0, options.padding)
		else
			padding = options.padding
		end
	else
		padding = UDim.new(0, 8)
	end

	local refs = Runtime.useInstance(function(ref)
		local style = Style.get()

		return create("Frame", {
			[ref] = "frame",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, style.itemHeight),

			create("UIListLayout", {
				[ref] = "layout",
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = padding,
			}),
		})
	end)

	refs.layout.HorizontalAlignment = options.alignment or Enum.HorizontalAlignment.Left
	refs.layout.VerticalAlignment = options.verticalAlignment or Enum.VerticalAlignment.Center
	refs.layout.Padding = padding

	Runtime.scope(fn)
end)

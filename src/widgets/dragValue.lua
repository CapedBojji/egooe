local UserInputService = game:GetService("UserInputService")

local Runtime = require(script.Parent.Parent.Runtime)
local Style = require(script.Parent.Parent.Style)
local create = require(script.Parent.Parent.create)
local createConnect = require(script.Parent.Parent.createConnect)

return Runtime.widget(function(options)
	options = options or {}

	local min = options.min or 0
	local max = options.max or 100
	local step = options.step or 1
	local initial = options.initial or min
	local value, setValue = Runtime.useState(initial)
	local dragging, setDragging = Runtime.useState(false)
	local hovered, setHovered = Runtime.useState(false)

	local refs = Runtime.useInstance(function(ref)
		local connectEvent = createConnect()
		local style = Style.get()

		ref.connection = nil
		ref.lastX = nil

		return create("TextButton", {
			[ref] = "btn",
			BackgroundColor3 = style.frameBgColor,
			BackgroundTransparency = style.frameBgTransparency,
			BorderSizePixel = 0,
			Font = Enum.Font.Code,
			TextColor3 = style.textColor,
			TextSize = style.textSize,
			Size = UDim2.new(1, 0, 0, style.itemHeight),
			AutoButtonColor = false,

			create("UICorner", {
				CornerRadius = UDim.new(0, 2),
			}),

			create("UIStroke", {
				[ref] = "stroke",
				Color = style.borderColor,
				Transparency = style.borderTransparency,
				Thickness = 1,
			}),

			MouseEnter = function()
				setHovered(true)
			end,

			MouseLeave = function()
				setHovered(false)
			end,

			InputBegan = function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return
				end

				ref.lastX = input.Position.X
				setDragging(true)

				if ref.connection then
					ref.connection:Disconnect()
				end

				ref.connection = connectEvent(UserInputService, "InputChanged", function(moveInput)
					if moveInput.UserInputType ~= Enum.UserInputType.MouseMovement then
						return
					end

					local dx = moveInput.Position.X - ref.lastX
					ref.lastX = moveInput.Position.X

					setValue(function(current)
						local steps = math.round(dx / 4)
						local newVal = current + steps * step
						return math.clamp(newVal, min, max)
					end)
				end)
			end,

			InputEnded = function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return
				end

				setDragging(false)

				if ref.connection then
					ref.connection:Disconnect()
					ref.connection = nil
				end
			end,
		})
	end)

	Runtime.useEffect(function()
		return function()
			if refs.connection then
				refs.connection:Disconnect()
				refs.connection = nil
			end
		end
	end)

	local style = Style.get()
	local currentValue = math.clamp(value, min, max)
	local displayValue = math.round(currentValue * (1 / step)) / (1 / step)

	if dragging then
		refs.btn.BackgroundColor3 = style.frameBgHoveredColor
		refs.btn.BackgroundTransparency = style.frameBgHoveredTransparency
	elseif hovered then
		refs.btn.BackgroundColor3 = style.frameBgHoveredColor
		refs.btn.BackgroundTransparency = style.frameBgHoveredTransparency * 1.5
	else
		refs.btn.BackgroundColor3 = style.frameBgColor
		refs.btn.BackgroundTransparency = style.frameBgTransparency
	end

	if options.label then
		refs.btn.Text = options.label .. ": " .. tostring(displayValue)
	else
		refs.btn.Text = tostring(displayValue)
	end

	return currentValue
end)

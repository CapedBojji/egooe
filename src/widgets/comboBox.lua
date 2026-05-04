export type ComboBoxHandle = {
	value: () -> string,
	changed: () -> boolean,
}

local Runtime = require(script.Parent.Parent.Runtime)
local Style = require(script.Parent.Parent.Style)
local create = require(script.Parent.Parent.create)

local ARROW = "▼"
local ITEM_HEIGHT = 22

return Runtime.widget(function(options)
	options = options or {}

	local items = options.items or {}
	local initialSelected = options.selected or (items[1] or "")

	local selectedValue, setSelectedValue = Runtime.useState(initialSelected)
	local selectedIndex, setSelectedIndex = Runtime.useState(function()
		for i, item in ipairs(items) do
			if item == initialSelected then
				return i
			end
		end
		return nil
	end)
	local changed, setChanged = Runtime.useState(false)
	local isOpen, setIsOpen = Runtime.useState(false)
	local hovered, setHovered = Runtime.useState(false)

	-- The combo button (in normal tree)
	local refs = Runtime.useInstance(function(ref)
		local style = Style.get()

		return create("TextButton", {
			[ref] = "btn",
			BackgroundColor3 = style.frameBgColor,
			BackgroundTransparency = style.frameBgTransparency,
			BorderSizePixel = 0,
			Font = Enum.Font.Code,
			TextColor3 = style.textColor,
			TextSize = style.textSize,
			TextXAlignment = Enum.TextXAlignment.Left,
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

			create("UIPadding", {
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6),
			}),

			create("TextLabel", {
				[ref] = "arrow",
				BackgroundTransparency = 1,
				Font = Enum.Font.Code,
				TextColor3 = style.textColor,
				TextSize = style.textSize,
				TextXAlignment = Enum.TextXAlignment.Right,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -6, 0.5, 0),
				Size = UDim2.new(0, 16, 1, 0),
				Text = ARROW,
				ZIndex = 2,
			}),

			MouseEnter = function()
				setHovered(true)
			end,

			MouseLeave = function()
				setHovered(false)
			end,

			Activated = function()
				setIsOpen(function(v)
					return not v
				end)
			end,
		})
	end)

	-- Dropdown overlay (created once, parented to root ScreenGui)
	Runtime.useEffect(function()
		local rootGui = Runtime.useRootInstance()
		if not rootGui then
			return
		end

		local style = Style.get()

		local dropdown = Instance.new("Frame")
		dropdown.Name = "ComboDropdown"
		dropdown.BackgroundColor3 = style.popupBgColor
		dropdown.BackgroundTransparency = 0
		dropdown.BorderSizePixel = 0
		dropdown.Size = UDim2.new(0, 160, 0, 0)
		dropdown.AutomaticSize = Enum.AutomaticSize.Y
		dropdown.ZIndex = 250
		dropdown.Visible = false
		dropdown.Parent = rootGui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 2)
		corner.Parent = dropdown

		local stroke = Instance.new("UIStroke")
		stroke.Color = style.borderColor
		stroke.Transparency = style.borderTransparency
		stroke.Thickness = 1
		stroke.Parent = dropdown

		local list = Instance.new("UIListLayout")
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Padding = UDim.new(0, 0)
		list.Parent = dropdown

		refs.dropdown = dropdown

		return function()
			if dropdown and dropdown.Parent then
				dropdown:Destroy()
			end
			refs.dropdown = nil
		end
	end)

	local style = Style.get()

	-- Update button visuals — always use internal selectedValue so it reflects clicks immediately
	refs.btn.Text = " " .. selectedValue
	refs.btn.TextSize = style.textSize
	refs.btn.TextColor3 = style.textColor

	if isOpen then
		refs.btn.BackgroundColor3 = style.frameBgHoveredColor
		refs.btn.BackgroundTransparency = style.frameBgHoveredTransparency
	elseif hovered then
		refs.btn.BackgroundColor3 = style.frameBgHoveredColor
		refs.btn.BackgroundTransparency = style.frameBgHoveredTransparency * 1.5
	else
		refs.btn.BackgroundColor3 = style.frameBgColor
		refs.btn.BackgroundTransparency = style.frameBgTransparency
	end

	-- Position and populate the dropdown
	if not isOpen then
		refs.hoveredItem = nil
	end

	if refs.dropdown then
		refs.dropdown.Visible = isOpen

		if isOpen then
			-- Align dropdown below the button
			local absPos = refs.btn.AbsolutePosition
			local absSize = refs.btn.AbsoluteSize

			refs.dropdown.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 2)
			refs.dropdown.Size = UDim2.new(0, absSize.X, 0, 0)

			-- Build item buttons once (only if not already built for this set of items)
			local existingCount = 0
			for _, child in ipairs(refs.dropdown:GetChildren()) do
				if child:IsA("TextButton") then
					existingCount += 1
				end
			end
			if existingCount ~= #items then
				for _, child in ipairs(refs.dropdown:GetChildren()) do
					if child:IsA("TextButton") then
						child:Destroy()
					end
				end

				for i, item in ipairs(items) do
					local itemBtn = Instance.new("TextButton")
					itemBtn.Name = "Item_" .. tostring(i)
					itemBtn.BorderSizePixel = 0
					itemBtn.Font = Enum.Font.Code
					itemBtn.TextColor3 = style.textColor
					itemBtn.TextSize = style.textSize
					itemBtn.TextXAlignment = Enum.TextXAlignment.Left
					itemBtn.Size = UDim2.new(1, 0, 0, ITEM_HEIGHT)
					itemBtn.ZIndex = 251
					itemBtn.AutoButtonColor = false
					itemBtn.LayoutOrder = i
					itemBtn.Parent = refs.dropdown

					local itemPadding = Instance.new("UIPadding")
					itemPadding.PaddingLeft = UDim.new(0, 8)
					itemPadding.PaddingRight = UDim.new(0, 8)
					itemPadding.Parent = itemBtn

					local capturedIndex = i
					local capturedItem = item
					itemBtn.MouseEnter:Connect(function()
						refs.hoveredItem = capturedIndex
					end)
					itemBtn.MouseLeave:Connect(function()
						if refs.hoveredItem == capturedIndex then
							refs.hoveredItem = nil
						end
					end)
					itemBtn.Activated:Connect(function()
						setSelectedValue(capturedItem)
						setSelectedIndex(capturedIndex)
						setChanged(true)
						setIsOpen(false)
					end)

					itemBtn.Text = capturedItem
				end
			end

			-- Update highlight for current selection and hover each frame
			for _, child in ipairs(refs.dropdown:GetChildren()) do
				if child:IsA("TextButton") then
					local childIndex = child.LayoutOrder
					local isSelected = childIndex == selectedIndex
					local isHovered = refs.hoveredItem == childIndex
					if isSelected then
						child.BackgroundColor3 = style.frameBgHoveredColor
						child.BackgroundTransparency = 0.5
					elseif isHovered then
						child.BackgroundColor3 = style.frameBgHoveredColor
						child.BackgroundTransparency = 0.7
					else
						child.BackgroundColor3 = style.buttonColor
						child.BackgroundTransparency = 1
					end
				end
			end
		end
	end

	return {
		value = function()
			return selectedValue
		end,
		changed = function()
			if changed then
				setChanged(false)
				return true
			end
			return false
		end,
	}
end)

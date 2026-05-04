--[=[
	@within EgooE
	@interface WindowOptions
	@within EgooE

	.title? string -- Window title
	.closable? boolean -- Show close button
	.movable? boolean -- Allow dragging
	.resizable? boolean -- Allow resizing
	.size? Vector2 -- Initial size in pixels, defaults to Vector2.new(300, 400)
	.position? Vector2 -- Initial position in pixels
]=]

--[=[
	@within EgooE
	@function window
	@tag widgets
	@param options string | WindowOptions -- Title string or options table
	@param children () -> () -- Children
	@return WindowHandle

	An Iris-styled window panel with title bar, scrollable content area, optional
	close button, dragging, and resizing. Unlike Plasma's window, this does **not**
	use automatic sizing — the window has an explicit size.

	Returns a handle with:
	- `closed()` – returns `true` once when the close button was clicked.

	```lua
	if window("My Window", function()
		label("Hello!")
	end):closed() then
		windowOpen = false
	end
	```
]=]

export type WindowHandle = {
	closed: () -> boolean,
}

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Runtime = require(script.Parent.Parent.Runtime)
local createConnect = require(script.Parent.Parent.createConnect)
local Style = require(script.Parent.Parent.Style)
local create = require(script.Parent.Parent.create)

local MIN_SIZE = Vector2.new(120, 80)

return Runtime.widget(function(options, fn)
	if type(options) == "string" then
		options = { title = options }
	end
	options = options or {}

	local closed, setClosed = Runtime.useState(false)
	local size, setSize = Runtime.useState(options.size or Vector2.new(300, 400))

	local refs = Runtime.useInstance(function(ref)
		local style = Style.get()

		local connectEvent = createConnect()
		ref.dragConnection = nil
		ref.resizeConnection = nil

		local initialSize = options.size or Vector2.new(300, 400)
		local titleBarHeight = style.titleBarHeight
		local contentHeight = initialSize.Y - titleBarHeight
		local padX = style.windowPadding.X
		local padY = style.windowPadding.Y

		create("Frame", {
			[ref] = "frame",
			BackgroundColor3 = style.windowBgColor,
			BackgroundTransparency = style.windowBgTransparency,
			BorderSizePixel = 0,
			Position = UDim2.new(
				0,
				options.position and options.position.X or 60,
				0,
				options.position and options.position.Y or 60
			),
			Size = UDim2.new(0, initialSize.X, 0, initialSize.Y),
			ClipsDescendants = true,

			create("UICorner", {
				CornerRadius = UDim.new(0, 0),
			}),

			create("UIStroke", {
				[ref] = "border",
				Color = style.borderColor,
				Transparency = style.borderTransparency,
				Thickness = 1,
			}),

			-- Title bar
			create("TextButton", {
				[ref] = "titleBar",
				BackgroundColor3 = style.titleBgActiveColor,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, titleBarHeight),
				Position = UDim2.new(0, 0, 0, 0),
				Text = "",
				Active = true,

				create("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4),
				}),

				create("UIPadding", {
					PaddingLeft = UDim.new(0, padX),
					PaddingRight = UDim.new(0, 4),
				}),

				create("TextLabel", {
					[ref] = "title",
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBold,
					TextColor3 = style.textColor,
					TextSize = style.textSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Size = UDim2.new(1, -20, 1, 0),
					LayoutOrder = 1,
				}),

				create("TextButton", {
					[ref] = "close",
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamBold,
					TextColor3 = Color3.fromRGB(200, 200, 200),
					TextSize = style.textSize + 2,
					Size = UDim2.new(0, 16, 0, 16),
					Text = "×",
					LayoutOrder = 2,
					Visible = options.closable or false,

					MouseEnter = function()
						ref.close.TextColor3 = Color3.fromRGB(255, 255, 255)
					end,

					MouseLeave = function()
						ref.close.TextColor3 = Color3.fromRGB(200, 200, 200)
					end,

					Activated = function()
						setClosed(true)
					end,
				}),

				InputBegan = function(clickInput)
					if not ref.titleBar.Active then
						return
					end
					if clickInput.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end

					local lastMousePosition = clickInput.Position

					-- Pop out of layout containers
					if
						ref.frame.Parent:FindFirstChildWhichIsA("UIGridStyleLayout")
						and not ref.frame.Parent:IsA("ScreenGui")
					then
						local beforePosition = ref.frame.AbsolutePosition
						local screenGui = ref.frame:FindFirstAncestorOfClass("ScreenGui")
						if screenGui.IgnoreGuiInset then
							beforePosition += GuiService:GetGuiInset()
						end
						ref.frame.Parent = screenGui
						ref.frame.Position = UDim2.new(0, beforePosition.X, 0, beforePosition.Y)
					end

					ref.dragConnection = connectEvent(UserInputService, "InputChanged", function(moveInput)
						if moveInput.UserInputType ~= Enum.UserInputType.MouseMovement then
							return
						end
						local delta = lastMousePosition - moveInput.Position
						lastMousePosition = moveInput.Position
						ref.frame.Position = ref.frame.Position - UDim2.new(0, delta.X, 0, delta.Y)
					end)
				end,

				InputEnded = function(input)
					if ref.dragConnection and input.UserInputType == Enum.UserInputType.MouseButton1 then
						ref.dragConnection:Disconnect()
						ref.dragConnection = nil
					end
				end,
			}),

			-- Scrollable content area
			create("ScrollingFrame", {
				[ref] = "container",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = style.scrollbarSize,
				ScrollBarImageColor3 = style.scrollbarGrabColor,
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				Position = UDim2.new(0, 0, 0, titleBarHeight),
				Size = UDim2.new(1, 0, 0, contentHeight),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,

				create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, style.itemSpacing.Y),
				}),

				create("UIPadding", {
					PaddingLeft = UDim.new(0, padX),
					PaddingRight = UDim.new(0, padX),
					PaddingTop = UDim.new(0, padY),
					PaddingBottom = UDim.new(0, padY),
				}),
			}),

			-- Resize grip (bottom-right corner)
			create("TextButton", {
				[ref] = "resizeGrip",
				BackgroundTransparency = 1,
				Text = "⊿",
				Font = Enum.Font.Gotham,
				TextSize = 14,
				TextColor3 = style.borderColor,
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, 0, 1, 0),
				Size = UDim2.new(0, 16, 0, 16),
				Rotation = 0,
				ZIndex = 5,

				InputBegan = function(clickInput)
					if clickInput.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end

					local initMousePos = clickInput.Position
					local initSize = ref.frame.AbsoluteSize

					ref.resizeConnection = connectEvent(UserInputService, "InputChanged", function(moveInput)
						if moveInput.UserInputType ~= Enum.UserInputType.MouseMovement then
							return
						end

						local delta =
							Vector2.new(moveInput.Position.X - initMousePos.X, moveInput.Position.Y - initMousePos.Y)

						local newSize = initSize + delta
						newSize = Vector2.new(math.max(MIN_SIZE.X, newSize.X), math.max(MIN_SIZE.Y, newSize.Y))

						ref.frame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
						ref.container.Size = UDim2.new(1, 0, 0, newSize.Y - titleBarHeight)
						setSize(newSize)
					end)
				end,

				InputEnded = function(input)
					if ref.resizeConnection and input.UserInputType == Enum.UserInputType.MouseButton1 then
						ref.resizeConnection:Disconnect()
						ref.resizeConnection = nil
					end
				end,
			}),
		})

		return ref.frame, ref.container
	end)

	-- Ensure drag/resize connections are cleaned up when the window is destroyed
	Runtime.useEffect(function()
		return function()
			if refs.dragConnection then
				refs.dragConnection:Disconnect()
				refs.dragConnection = nil
			end
			if refs.resizeConnection then
				refs.resizeConnection:Disconnect()
				refs.resizeConnection = nil
			end
		end
	end)

	-- Apply options
	local movable = if options.movable ~= nil then options.movable else true
	local resizable = if options.resizable ~= nil then options.resizable else true

	refs.titleBar.Active = movable
	refs.resizeGrip.Visible = resizable
	refs.close.Visible = options.closable or false
	refs.title.Text = options.title or ""
	refs.title.Size = UDim2.new(1, if options.closable then -24 else 0, 1, 0)

	-- Run children inside the scrollable container
	Runtime.scope(fn)

	local handle = {
		closed = function()
			if closed then
				setClosed(false)
				return true
			end
			return false
		end,
	}

	return handle
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IrisPlasma = require(ReplicatedStorage:WaitForChild("IrisPlasma"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "IrisPlasmaDemo"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local node = IrisPlasma.new(screenGui)

RunService.RenderStepped:Connect(function()
	IrisPlasma.start(node, function()
		IrisPlasma.window({
			title = "Iris Plasma Test",
			size = Vector2.new(360, 320),
			position = Vector2.new(48, 48),
		}, function()
			IrisPlasma.heading("Immediate-Mode UI")
			IrisPlasma.label("If you can click and type, test setup works.")
			IrisPlasma.separator()

			local clickCount, setClickCount = IrisPlasma.useState(0)
			if IrisPlasma.button("Click me"):clicked() then
				setClickCount(clickCount + 1)
			end
			IrisPlasma.label(string.format("Clicks: %d", clickCount))

			local checked, setChecked = IrisPlasma.useState(false)
			if IrisPlasma.checkbox("Enable option", { checked = checked }):clicked() then
				setChecked(not checked)
			end
			IrisPlasma.label("Checkbox: " .. tostring(checked))

			local value = IrisPlasma.slider({ min = 0, max = 100, initial = 35, label = "Volume" })
			IrisPlasma.label(string.format("Slider: %.1f", value))

			local inputHandle = IrisPlasma.input({ placeholder = "Type here..." })
			if inputHandle:submitted() then
				print("IrisPlasma input submitted:", inputHandle:value())
			end
		end)
	end)
end)

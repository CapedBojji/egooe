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
		IrisPlasma.demoWindow()
	end)
end)

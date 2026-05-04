local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EgooE = require(ReplicatedStorage:WaitForChild("EgooE"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EgooEDemo"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local node = EgooE.new(screenGui)

RunService.RenderStepped:Connect(function()
	EgooE.start(node, function()
		EgooE.demoWindow()
	end)
end)

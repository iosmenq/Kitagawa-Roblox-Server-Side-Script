local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local decalID = "rbxassetid://76778926050388"
local particleTexture = "http://www.roblox.com/asset/?id=75585190658263"
local active = false
local spawnedDecals = {}
local spawnedParticles = {}
local customSky
local originalSky = Lighting:FindFirstChildOfClass("Sky")
local originalSkyClone
if originalSky then
	originalSkyClone = originalSky:Clone()
end

local function SpamDecals(root)
	for _,obj in pairs(root:GetChildren()) do
		if obj:IsA("BasePart") then
			local faces={Enum.NormalId.Front,Enum.NormalId.Back,Enum.NormalId.Right,Enum.NormalId.Left,Enum.NormalId.Top,Enum.NormalId.Bottom}
			local decals={}
			for _,face in pairs(faces) do
				local d=Instance.new("Decal")
				d.Texture=decalID
				d.Face=face
				d.Parent=obj
				table.insert(decals,d)
			end
			table.insert(spawnedDecals,decals)
		end
		SpamDecals(obj)
	end
end

local function ClearDecals()
	for _,group in pairs(spawnedDecals) do
		for _,d in pairs(group) do
			if d and d.Parent then
				d:Destroy()
			end
		end
	end
	spawnedDecals={}
end

local function SpawnParticles()
	for _,p in pairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Head") then
			local pe=Instance.new("ParticleEmitter")
			pe.Texture=particleTexture
			pe.Parent=p.Character.Head
			table.insert(spawnedParticles,pe)
		end
	end
end

local function ClearParticles()
	for _,pe in pairs(spawnedParticles) do
		if pe and pe.Parent then
			pe:Destroy()
		end
	end
	spawnedParticles={}
end

local function EnableSky()
	customSky=Instance.new("Sky")
	local id="9427965187"
	customSky.SkyboxBk="http://www.roblox.com/asset/?id="..id
	customSky.SkyboxDn="http://www.roblox.com/asset/?id="..id
	customSky.SkyboxFt="http://www.roblox.com/asset/?id="..id
	customSky.SkyboxLf="http://www.roblox.com/asset/?id="..id
	customSky.SkyboxRt="http://www.roblox.com/asset/?id="..id
	customSky.SkyboxUp="http://www.roblox.com/asset/?id="..id
	customSky.Parent=Lighting
end

local function DisableSky()
	if customSky then
		customSky:Destroy()
	end
	if originalSkyClone then
		originalSkyClone.Parent=Lighting
	end
end

local function Toggle()
	if not active then
		active=true
		SpamDecals(Workspace)
		SpawnParticles()
		EnableSky()
	else
		active=false
		ClearDecals()
		ClearParticles()
		DisableSky()
	end
end

local function ShowHint()
	StarterGui:SetCore("ResetButtonCallback",true)
	for _,hint in pairs(Workspace:GetChildren()) do
		if hint:IsA("Hint") then
			hint:Destroy()
		end
	end
	local hint = Instance.new("Hint")
	hint.Text = "Kitagawa Here!"
	hint.Parent = Workspace
end

local function CreateGui(player)
	if player.Name~="YOUR_ROBLOX_USERNAME" then return end
	local gui=Instance.new("ScreenGui")
	gui.Name="AdminPanel"
	gui.ResetOnSpawn=false

	local frame=Instance.new("Frame")
	frame.Size=UDim2.new(0,200,0,60)
	frame.Position=UDim2.new(0,50,0,50)
	frame.BackgroundColor3=Color3.fromRGB(40,40,40)
	frame.Active=true
	frame.Draggable=true
	frame.Parent=gui

	local uicorner=Instance.new("UICorner")
	uicorner.CornerRadius=UDim.new(0,12)
	uicorner.Parent=frame

	local button=Instance.new("TextButton")
	button.Size=UDim2.new(1,0,1,0)
	button.Text="ON"
	button.BackgroundColor3=Color3.fromRGB(0,255,0)
	button.TextColor3=Color3.new(1,1,1)
	button.Parent=frame

	button.MouseButton1Click:Connect(function()
		Toggle()
		ShowHint()
		if active then
			button.Text="OFF"
			button.BackgroundColor3=Color3.fromRGB(255,0,0)
		else
			button.Text="ON"
			button.BackgroundColor3=Color3.fromRGB(0,255,0)
		end
	end)

	gui.Parent=player:WaitForChild("PlayerGui")
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Wait()
	CreateGui(player)
end)

for _,p in pairs(Players:GetPlayers()) do
	CreateGui(p)
end

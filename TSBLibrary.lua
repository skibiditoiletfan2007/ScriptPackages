local v0 = {
	EFP = game.Workspace.Thrown
}
local v1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/BoatTween.lua"))()
local l_TweenService_0 = game:GetService("TweenService")
v0.ProcessPart = function(v3) 
	local l_Maid_0 = v3.Maid
	local l_FX_0 = v3.FX
	local l_Part_0 = v3.Part
	local v7 = v3.Debri or 10
	local v8 = l_Maid_0:give(l_FX_0:Clone())
	for _, v10 in pairs(v8:GetChildren()) do
		l_Maid_0:give(v10)
		game.Debris:AddItem(v10, v7)
		v10.Parent = l_Part_0
	end
end
v0.PlayTween = function(v11, v12, v13)
	local v14 = v1:Create(v11, v12)
	v14:Play()
	local v15 = v14.Completed:Once(function()
		if v13 then
			v13()
		end
		v14:Destroy()
	end)
	task.delay(v12.Time, function()
		v15:Disconnect()
		v14:Destroy()
	end)
end

local MaidTable = {
	ClassName = "Maid"
}
MaidTable.new = function() 
	return (setmetatable({
		_tasks = {}
	}, MaidTable))
end
MaidTable.isMaid = function(v1) 
	local v2 = false
	if type(v1) == "table" then
		v2 = v1.ClassName == "Maid"
	end
	return v2
end
MaidTable.__index = function(v3, v4) 
	if MaidTable[v4] then
		return MaidTable[v4]
	else
		return v3._tasks[v4]
	end
end
MaidTable.__newindex = function(v5, v6, v7) 
	if MaidTable[v6] ~= nil then
		error(("'%s' is reserved"):format((tostring(v6))), 2)
	end
	local l__tasks_0 = v5._tasks
	local v9 = l__tasks_0[v6]
	if v9 == v7 then
		return
	else
		l__tasks_0[v6] = v7
		if v9 then
			if type(v9) == "function" then
				v9()
				return
			elseif typeof(v9) == "RBXScriptConnection" then
				v9:Disconnect()
				return
			elseif v9.Destroy then
				v9:Destroy()
				return
			elseif v9.destroy then
				v9:destroy()
			end
		end
		return
	end
end
MaidTable.giveTask = function(v10, v11) 
	if not v11 then
		error("Task cannot be false or nil", 2)
	end
	local v12 = #v10._tasks + 1
	v10[v12] = v11
	if type(v11) == "table" and not v11.Destroy and not v11.destroy then
		warn("[Maid.GiveTask] - Gave table task without .Destroy\n\n" .. debug.traceback())
	end
	return v12
end
MaidTable.give = function(v13, v14) 
	local __ = nil
	if type(v14) == "table" and v14.isAPromise then
		local v16, v17 = v13:givePromise(v14)
		_ = v16
		return v14, v17
	else
		return v14, (v13:giveTask(v14))
	end
end
MaidTable.doCleaning = function(v18) 
	local l__tasks_1 = v18._tasks
	for v20, v21 in pairs(l__tasks_1) do
		if typeof(v21) == "RBXScriptConnection" then
			l__tasks_1[v20] = nil
			v21:Disconnect()
		end
	end
	local v22, v23 = next(l__tasks_1)
	while v23 ~= nil do
		l__tasks_1[v22] = nil
		if type(v23) == "function" then
			v23()
		elseif typeof(v23) == "RBXScriptConnection" then
			v23:Disconnect()
		elseif v23.Destroy then
			v23:Destroy()
		elseif v23.destroy then
			v23:destroy()
		end
		local v24, v25 = next(l__tasks_1)
		v22 = v24
		v23 = v25
	end
end
MaidTable.destroy = MaidTable.doCleaning
MaidTable.clean = MaidTable.doCleaning
v0.Maid = MaidTable

local BezierTable = {};
Lerp = function(v1, v2, v3) 
	return v1 + (v2 - v1) * v3
end
BezierTable.Quad = function(v4, v5, v6, v7) 
	local v8 = Lerp(v4, v5, v7)
	local v9 = Lerp(v5, v6, v7)
	return Lerp(v8, v9, v7)
end
v0.Bezier = BezierTable

v0.Impact = function(v16)
	local v17 = v16:Clone()
	v17.Parent = game.Lighting
	delay(0.1, function()
		v17:Destroy()
	end)
end
v0.ChangeParticleColor = function(v18)
	local l_Particle_0 = v18.Particle
	local l_Color_0 = v18.Color
	local v21 = v18.Position or v18.Pos
	local v22 = {}
	if l_Particle_0:IsA("ParticleEmitter") then
		table.insert(v22, l_Particle_0)
	else
		for _, v24 in pairs(l_Particle_0:GetDescendants()) do
			if v24:IsA("ParticleEmitter") then
				table.insert(v22, v24)
			end
		end
	end
	for _, v26 in pairs(v22) do
		if l_Color_0 then
			local v27 = {
				ColorSequenceKeypoint.new(0, l_Color_0), 
				ColorSequenceKeypoint.new(1, l_Color_0)
			}
			v26.Color = ColorSequence.new(v27)
		else
			local v28 = Ray.new(v21, (Vector3.new(0, -100, 0, 0)))
			local l_PartOnRayWithWhitelist_0 = game.Workspace:FindPartOnRayWithWhitelist(v28, {
				game.Workspace.World
			})
			if l_PartOnRayWithWhitelist_0 then
				local v30 = {
					ColorSequenceKeypoint.new(0, l_PartOnRayWithWhitelist_0.Color), 
					ColorSequenceKeypoint.new(1, l_PartOnRayWithWhitelist_0.Color)
				}
				v26.Color = ColorSequence.new(v30)
			end
		end
	end
end
local v31 = RaycastParams.new()
v31.FilterType = Enum.RaycastFilterType.Include
v31.FilterDescendantsInstances = {
	workspace.Map,
	workspace.Built,
}
v0.SetSmoke = function(v32)
	local l_FX_1 = v32.FX
	local v34 = v32.Dist or 20
	local l_Anchor_0 = v32.Anchor
	local v36 = game.Workspace:Raycast(l_Anchor_0.Position, Vector3.new(0, -v34, 0), v31)
	if v36 then
		local v37 = {
			ColorSequenceKeypoint.new(0, v36.Instance.Color), 
			ColorSequenceKeypoint.new(1, v36.Instance.Color)
		}
		for _, v39 in pairs(l_FX_1:GetDescendants()) do
			if v39:IsA("ParticleEmitter") then
				v39.Color = ColorSequence.new(v37)
			end
		end
		return v36
	else
		return
	end
end
v0.BindScale = function(v40)
	local l_FX_2 = v40.FX
	local l_Maid_1 = v40.Maid
	local v43 = v40.Init or 1
	local v44 = l_Maid_1:give(Instance.new("NumberValue"))
	v44.Value = v43
	v44:giveTask(v44.Changed:Connect(function()
		l_FX_2:ScaleTo(v44.Value)
	end))
	return v44
end
v0.Able = function(v45)
	local l_FX_3 = v45.FX
	if v45.On then
		for _, v48 in pairs(l_FX_3:GetDescendants()) do
			if v48:IsA("ParticleEmitter") then
				v48.Enabled = true
			end
		end
		return
	else
		for _, v50 in pairs(l_FX_3:GetDescendants()) do
			if v50:IsA("ParticleEmitter") then
				v50.Enabled = false
			end
		end
		return
	end
end
v0.WeldObject = function(...)
	local v51, v52, v53, v54, v55, v56 = ...
	local v57 = v51:Clone()
	local l_Weld_0 = Instance.new("Weld")
	l_Weld_0.Parent = v52
	l_Weld_0.Part1 = v57.PrimaryPart
	l_Weld_0.Part0 = v52
	v57.Parent = v52.Parent
	v57.Name = "ModuleWelded"
	if v53 then
		for _, v60 in pairs(v57:GetDescendants()) do
			if v60:IsA("ParticleEmitter") or v60:IsA("Trail") then
				task.delay(v53, function()
					v60.Enabled = false
					task.wait(2)
					v57:Destroy()
				end)
			end
		end
		return
	elseif v56 then
		task.delay(v55, function()
			for _, v62 in pairs(v57:GetDescendants()) do
				if v62:IsA("BasePart") then
					v62.Transparency = 1
				end
			end
			for _, v64 in pairs(v57:GetDescendants()) do
				if v64:IsA("ParticleEmitter") and v64.Enabled == true or v64:IsA("Beam") or v64:IsA("Texture") or v64:IsA("Decal") then
					v64:Destroy()
				end
			end
			for _, v66 in pairs(v57:GetDescendants()) do
				if v66:IsA("ParticleEmitter") then
					v66:Emit(v66:GetAttribute("EmitCount"))
				end
			end
			task.wait(3)
			v57:Destroy()
		end)
		return
	elseif v55 then
		task.delay(v55, function()
			v57:Destroy()
		end)
		return
	else
		if v54 then
			task.delay(v54, function()
				l_Weld_0:Destroy()
				v57.Parent = workspace.Effects
				task.wait(0.08)
				for _, v68 in pairs(v57:GetDescendants()) do
					if v68:IsA("BasePart") then
						v68.CanCollide = true
					end
				end
				for _, v70 in pairs(v57:GetDescendants()) do
					if v70:IsA("ParticleEmitter") then
						v70.Enabled = false
					end
				end
				task.wait(1.5)
				for _, v72 in pairs(v57:GetDescendants()) do
					if v72:IsA("BasePart") then
						l_TweenService_0:Create(v72, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
							Transparency = 1
						}):Play()
					end
				end
				task.wait(0.5)
				v57:Destroy()
			end)
		end
		return
	end
end
v0.QuickWeld = function(v73)
	local l_FX_4 = v73.FX
	local v75 = v73.C0 or CFrame.new(0, 0, 0)
	local l_P_0 = v73.P
	local l_Maid_2 = v73.Maid
	l_FX_4 = l_FX_4:Clone()
	local l_Weld_1 = Instance.new("Weld")
	if l_FX_4:IsA("Model") then
		l_Weld_1.Part0 = l_FX_4.PrimaryPart
	else
		l_Weld_1.Part0 = l_FX_4
	end
	l_Weld_1.Part1 = l_P_0
	l_Weld_1.C0 = v75
	l_Weld_1.Parent = l_FX_4
	l_FX_4.Parent = v0.EFP
	l_Maid_2:give(l_FX_4)
	return l_FX_4, l_Weld_1
end
v0.QuickFX = function(v79)
	local l_FX_5 = v79.FX
	local l_Anchor_1 = v79.Anchor
	local l_Maid_3 = v79.Maid
	if v79.Ray then
		local v83 = game.Workspace:Raycast(l_Anchor_1.Position, Vector3.new(0, -10, 0, 0), v31)
		if v83 then
			local v84, v85, v86 = l_Anchor_1:ToOrientation()
			l_Anchor_1 = CFrame.new(v83.Position) * CFrame.Angles(v84, v85, v86)
		else
			return
		end
	end
	l_FX_5 = l_FX_5:Clone()
	if l_FX_5:IsA("Model") then
		l_FX_5:PivotTo(l_Anchor_1)
	elseif l_FX_5:IsA("BasePart") then
		l_FX_5.CFrame = l_Anchor_1
	end
	if l_FX_5:IsA("Attachment") then
		l_FX_5.Parent = l_Anchor_1
	else
		l_FX_5.Parent = v0.EFP
	end
	l_Maid_3:give(l_FX_5)
	return l_FX_5
end
v0.LifeScale = function(v87)
	local l_FX_6 = v87.FX
	local l_Scale_0 = v87.Scale
	for _, v91 in pairs(l_FX_6:GetDescendants()) do
		if v91:IsA("ParticleEmitter") then
			v91.Lifetime = NumberRange.new(v91.Lifetime.Min * l_Scale_0, v91.Lifetime.Max * l_Scale_0)
		end
	end
end
v0.dtwait = function(v92)
	local v93 = 0
	while v93 < v92 do
		v93 = v93 + game:GetService("RunService").Heartbeat:Wait()
	end
	return v93
end
v0.RaiseZIndex = function(v94)
	local l_FX_7 = v94.FX
	local l_Count_0 = v94.Count
	for _, v98 in pairs(l_FX_7:GetDescendants()) do
		if v98:IsA("ParticleEmitter") then
			v98.ZOffset = v98.ZOffset + l_Count_0
		end
	end
end
v0.WeldObject = function(...)
	local v99, v100, v101, v102, v103, v104 = ...
	local v105 = v99:Clone()
	local l_Weld_2 = Instance.new("Weld")
	l_Weld_2.Parent = v100
	l_Weld_2.Part1 = v105.PrimaryPart
	l_Weld_2.Part0 = v100
	v105.Parent = v100.Parent
	v105.Name = "ModuleWelded"
	if v101 then
		for _, v108 in pairs(v105:GetDescendants()) do
			if v108:IsA("ParticleEmitter") or v108:IsA("Trail") then
				task.delay(v101, function()
					v108.Enabled = false
					task.wait(2)
					v105:Destroy()
				end)
			end
		end
		return
	elseif v104 then
		task.delay(v103, function()
			for _, v110 in pairs(v105:GetDescendants()) do
				if v110:IsA("BasePart") then
					v110.Transparency = 1
				end
			end
			for _, v112 in pairs(v105:GetDescendants()) do
				if v112:IsA("ParticleEmitter") and v112.Enabled == true or v112:IsA("Beam") or v112:IsA("Texture") or v112:IsA("Decal") then
					v112:Destroy()
				end
			end
			for _, v114 in pairs(v105:GetDescendants()) do
				if v114:IsA("ParticleEmitter") then
					v114:Emit(v114:GetAttribute("EmitCount"))
				end
			end
			task.wait(3)
			v105:Destroy()
		end)
		return
	elseif v103 then
		task.delay(v103, function()
			v105:Destroy()
		end)
		return
	else
		if v102 then
			task.delay(v102, function()
				l_Weld_2:Destroy()
				v105.Parent = workspace.Effects
				task.wait(0.08)
				for _, v116 in pairs(v105:GetDescendants()) do
					if v116:IsA("BasePart") then
						v116.CanCollide = true
					end
				end
				for _, v118 in pairs(v105:GetDescendants()) do
					if v118:IsA("ParticleEmitter") then
						v118.Enabled = false
					end
				end
				task.wait(1.5)
				for _, v120 in pairs(v105:GetDescendants()) do
					if v120:IsA("BasePart") then
						l_TweenService_0:Create(v120, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
							Transparency = 1
						}):Play()
					end
				end
				task.wait(0.5)
				v105:Destroy()
			end)
		end
		return
	end
end
v0.PlayAttachment = function(v121, v122, v123)
	local v124 = nil
	if not v121:IsA("Part") and v121:IsA("Model") then
		v124 = v121.PrimaryPart
	end
	print(v124)
	local v125 = false
	if v124 then
		v125 = game.Workspace:Raycast(v124.Position, Vector3.new(0, -10, 0, 0), v31) and true or false
	end
	for _, v127 in pairs(v121:GetDescendants()) do
		if v127:IsA("ParticleEmitter") then
			local l_v127_Attributes_0 = v127:GetAttributes()
			local l_EmitDelay_0 = l_v127_Attributes_0.EmitDelay
			local v130 = l_v127_Attributes_0.RepeatCount or 1
			local l_RepeatDelay_0 = l_v127_Attributes_0.RepeatDelay
			local l_v130_0 = v130
			local l_l_EmitDelay_0_0 = l_EmitDelay_0
			local l_l_v127_Attributes_0_0 = l_v127_Attributes_0
			local l_l_RepeatDelay_0_0 = l_RepeatDelay_0
			task.spawn(function()
				for _ = 1, l_v130_0 do
					if l_l_EmitDelay_0_0 then
						task.delay(l_l_EmitDelay_0_0, function()
							v127:Emit(l_l_v127_Attributes_0_0.EmitCount)
						end)
					else
						v127:Emit(l_l_v127_Attributes_0_0.EmitCount)
					end
					if l_l_v127_Attributes_0_0.EmitDuration then
						v127.Enabled = true
						task.delay(l_l_v127_Attributes_0_0.EmitDuration, function()
							v127.Enabled = false
						end)
					end
					if l_l_RepeatDelay_0_0 then
						task.wait(l_l_RepeatDelay_0_0)
					end
				end
			end)
		end
		if v127:IsA("PointLight") and v122 then
			v0.PlayTween(v127, {
				EasingStyle = "Sine", 
				Time = v122, 
				Goal = {
					Brightness = 0
				}
			})
		end
		if v127:IsA("Beam") then
			local l_v127_Attributes_1 = v127:GetAttributes()
			local l_Duration_0 = l_v127_Attributes_1.Duration
			local v139 = 0.5
			if v123 and v123.TweenTime then
				v139 = v123.TweenTime
			end
			do
				local l_v139_0 = v139
				local function v141()
					game:GetService("TweenService"):Create(v127, TweenInfo.new(l_v139_0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
						Width1 = 0, 
						Width0 = 0
					}):Play()
				end
				(function()
					game:GetService("TweenService"):Create(v127, TweenInfo.new(l_v139_0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
						Width1 = l_v127_Attributes_1.Width1, 
						Width0 = l_v127_Attributes_1.Width0
					}):Play()
				end)()
				if l_Duration_0 then
					task.delay(l_Duration_0, function()
						v141()
					end)
				end
			end
		end
	end
	if v122 then
		game.Debris:AddItem(v121, v122)
	end
end
v0.Yield = function(v142)
	local v143 = v142.Time or 5
	local l_Char_0 = v142.Char
	local l_Event_0 = v142.Event
	local v146 = tick()
	while true do
		if tick() - v146 < v143 then
			local l_l_Char_0_FirstChild_0 = l_Char_0:FindFirstChild(l_Event_0)
			if l_l_Char_0_FirstChild_0 then
				return l_l_Char_0_FirstChild_0
			else
				v0.dtwait(0.01)
			end
		else
			return
		end
	end
end
v0.PlayAttachment = function(v148, v149, v150)
	for _, v152 in pairs(v148:GetDescendants()) do
		if v152:IsA("ParticleEmitter") then
			local l_v152_Attributes_0 = v152:GetAttributes()
			local l_EmitDelay_1 = l_v152_Attributes_0.EmitDelay
			if l_EmitDelay_1 then
				local l_l_v152_Attributes_0_0 = l_v152_Attributes_0
				task.delay(l_EmitDelay_1, function()
					v152:Emit(l_l_v152_Attributes_0_0.EmitCount)
				end)
			else
				v152:Emit(l_v152_Attributes_0.EmitCount)
			end
			if l_v152_Attributes_0.EmitDuration then
				v152.Enabled = true
				task.delay(l_v152_Attributes_0.EmitDuration, function()
					v152.Enabled = false
				end)
			end
		end
		if v152:IsA("PointLight") and v149 then
			v0.PlayTween(v152, {
				EasingStyle = "Sine", 
				Time = v149, 
				Goal = {
					Brightness = 0
				}
			})
		end
		if v152:IsA("Beam") then
			local l_v152_Attributes_1 = v152:GetAttributes()
			local l_Duration_1 = l_v152_Attributes_1.Duration
			local v158 = 0.5
			if v150 and v150.TweenTime then
				v158 = v150.TweenTime
			end
			do
				local l_v158_0 = v158
				local function v160()
					game:GetService("TweenService"):Create(v152, TweenInfo.new(l_v158_0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
						Width1 = 0, 
						Width0 = 0
					}):Play()
				end
				(function()
					game:GetService("TweenService"):Create(v152, TweenInfo.new(l_v158_0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
						Width1 = l_v152_Attributes_1.Width1, 
						Width0 = l_v152_Attributes_1.Width0
					}):Play()
				end)()
				if l_Duration_1 then
					task.delay(l_Duration_1, function()
						v160()
					end)
				end
			end
		end
	end
	if v149 then
		game.Debris:AddItem(v148, v149)
	end
end

v0.FastSpawn = function(v0, ...) 
	assert(type(v0) == "function")
	local v1 = {
		...
	}
	local v2 = select("#", ...)
	local l_BindableEvent_0 = Instance.new("BindableEvent")
	l_BindableEvent_0.Event:Connect(function() 
		v0(unpack(v1, 1, v2))
	end)
	l_BindableEvent_0:Fire()
	l_BindableEvent_0:Destroy()
end

v0.RandomRot = function()
	return CFrame.Angles(0, math.rad((math.random(-360, 360))), 0)
end
v0.PlayMesh = function(v161)
	task.spawn(function()
		local l_Model_0 = v161.Model
		local v163 = v161.Info or TweenInfo.new(1, Enum.EasingStyle.Sine)
		local l_Start_0 = l_Model_0:FindFirstChild("Start")
		local l_End_0 = l_Model_0:FindFirstChild("End")
		local l_Stay_0 = v161.Stay
		local l_Anchor_2 = v161.Anchor
		local v168 = v161.EndT or 1
		local l_Del_0 = v161.Del
		local l_Skip_0 = v161.Skip
		if l_Start_0 and l_End_0 then
			l_Model_0.PrimaryPart = l_Start_0
			if not l_Skip_0 then
				for _, v172 in pairs(l_Model_0:GetChildren()) do
					if v172:IsA("BasePart") then
						v172.CanCollide = false
						v172.Anchored = true
					end
				end
			end
			if l_Anchor_2 then
				l_Model_0:SetPrimaryPartCFrame(l_Anchor_2)
			end
			if v161.T then
				l_Start_0.Transparency = v161.T
			end
			l_End_0.Transparency = 1
			l_Model_0.Parent = v0.EFP
			local l_Decal_0 = l_Start_0:FindFirstChildOfClass("Decal")
			local l_SpecialMesh_0 = l_Start_0:FindFirstChildOfClass("SpecialMesh")
			local l_SpecialMesh_1 = l_End_0:FindFirstChildOfClass("SpecialMesh")
			local l_Decal_1 = l_End_0:FindFirstChildOfClass("Decal")
			if l_Decal_1 and not l_Skip_0 then
				l_Decal_1.Transparency = 1
			end
			local v177 = nil
			if l_Del_0 then
				game:GetService("TweenService"):Create(l_Start_0, v163, {
					Size = l_End_0.Size, 
					CFrame = l_End_0.CFrame
				}):Play()
				task.delay(l_Del_0, function()
					v177 = game:GetService("TweenService"):Create(l_Start_0, v163, {
						Transparency = v168
					})
					v177:Play()
					if l_Decal_0 then
						for _, v179 in pairs(l_Start_0:GetChildren()) do
							if v179:IsA("Decal") then
								game:GetService("TweenService"):Create(v179, v163, {
									Transparency = v168, 
									Color = l_Decal_1.Color
								}):Play()
								print(l_Decal_1.Color)
							end
						end
					end
					if l_SpecialMesh_0 then
						v177 = game:GetService("TweenService"):Create(l_SpecialMesh_0, v163, {
							Scale = l_SpecialMesh_1.Scale
						}):Play()
					end
				end)
			else
				if l_SpecialMesh_0 then
					game:GetService("TweenService"):Create(l_SpecialMesh_0, v163, {
						Scale = l_SpecialMesh_1.Scale
					}):Play()
				end
				if l_Decal_0 then
					for _, v181 in pairs(l_Start_0:GetChildren()) do
						if v181:IsA("Decal") then
							game:GetService("TweenService"):Create(v181, v163, {
								Transparency = v168
							}):Play()
						end
					end
					v177 = game:GetService("TweenService"):Create(l_Start_0, v163, {
						Size = l_End_0.Size, 
						CFrame = l_End_0.CFrame
					})
					v177:Play()
				else
					v177 = game:GetService("TweenService"):Create(l_Start_0, v163, {
						Size = l_End_0.Size, 
						Transparency = v168, 
						CFrame = l_End_0.CFrame
					})
					v177:Play()
				end
			end
			if not l_Stay_0 then
				if l_Del_0 then
					task.wait(l_Del_0 + 0.1)
				end
				v177.Completed:Connect(function()
					l_Model_0:Destroy()
				end)
			elseif l_Stay_0 then
				game.Debris:AddItem(l_Model_0, l_Stay_0)
			end
			return
		else
			warn("NO START OR END")
			return
		end
	end)
end
v0.PlayFlipBook = function(v182)
	local l_Mesh_0 = v182.Mesh
	local v184 = v182.Delta or 0.02
	local l_DWC_0 = v182.DWC
	local v186 = v182.Repeat or 1
	local v187 = v182.FPS or 1
	local _ = v182.Loop
	local l_Folder_0 = l_Mesh_0:FindFirstChild("Folder")
	local l_Decal_2 = l_Mesh_0:FindFirstChild("Decal")
	if l_DWC_0 == nil then
		l_DWC_0 = true
	end
	if l_Folder_0 and l_Decal_2 then
		v0.FastSpawn(function()
			for _ = 1, v186 do
				if l_Mesh_0:IsDescendantOf(game.Workspace) then
					for v192 = 1, #l_Folder_0:GetChildren(), v187 do
						local v193 = l_Folder_0:FindFirstChild((tostring(v192))) or l_Folder_0:GetChildren()[#l_Folder_0:GetChildren()]
						if v193 then
							l_Decal_2.Texture = v193.Texture
						end
						if v184 == "Step" then
							game:GetService("RunService").RenderStepped:Wait()
						else
							v0.dtwait(v184)
						end
					end
				else
					break
				end
			end
			if l_DWC_0 and l_DWC_0 ~= false then
				l_Mesh_0:Destroy()
			end
		end)
	end
end
v0.GlassLight = function(v194)
	local l_Highlight_0 = Instance.new("Highlight")
	l_Highlight_0.FillTransparency = 1
	l_Highlight_0.OutlineTransparency = 1
	l_Highlight_0.Parent = v194
end
return v0

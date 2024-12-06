local l_RunService_0 = game:GetService("RunService");
local l_TweenService_0 = game:GetService("TweenService");
local v3 = {};
local v4 = {};
local v5 = {};
local v6 = Random.new(12312);
v3.EmitParticlesAlt = function(_, v8)
	for _, v10 in pairs(v8:GetDescendants()) do
		if v10:IsA("ParticleEmitter") then
			v10:Emit(v10:GetAttribute("EmitCount"), v10:GetAttribute("EmitDelay"));
		end;
	end;
end;
v3.AddToCoreLoop = function(_, v12)
	table.insert(v4, v12);
end;
v3.FetchQuickPart = function(_)
	local l_Part_0 = Instance.new("Part");
	l_Part_0.Anchored = false;
	l_Part_0.CanCollide = false;
	l_Part_0.Transparency = 1;
	l_Part_0.CanCollide = false;
	l_Part_0.CastShadow = false;
	l_Part_0.Massless = true;
	l_Part_0.CanQuery = false;
	return l_Part_0;
end;
v3.AddTempFunction = function(_, v16, v17)
	local v18 = v17 or true;
	local v19 = nil;
	v19 = if v18 then {
		callback = v16, 
		Creation = os.clock(), 
		HasWarned = false, 
		traceback = debug.traceback()
	} else {
			callback = v16, 
			DONTWARN = true
		};
	table.insert(v5, v19);
end;
v3.BindWithSpacing = function(_, v21, v22, v23, v24)
	local v25 = os.clock();
	local l_v25_0 = v25;
	local v27 = false;
	v3:AddTempFunction(function()
		local v28 = os.clock() - l_v25_0;
		if v22 < v28 then
			l_v25_0 = os.clock() + v22;
			local v29 = (os.clock() - v25) / v23;
			local v30 = Lerp(1, 0, v29);
			v21((os.clock() - v25) / v23, v28, v30, os.clock() - v25);
		end;
		if not v27 and v23 < os.clock() - v25 then
			v27 = true;
			if v24 then
				v24((os.clock() - v25) / v23, v28);
			end;
			return true;
		else
			return;
		end;
	end);
end;
v3.FadePointLightIn = function(_, v32, v33)
	local l_Brightness_0 = v32.Brightness;
	local l_Range_0 = v32.Range;
	v32.Brightness = 0;
	v32.Range = 0;
	l_TweenService_0:Create(v32, TweenInfo.new(v33), {
		Brightness = l_Brightness_0, 
		Range = l_Range_0
	}):Play();
end;
v3.DisableAllVisuals = function(_, v37)
	for _, v39 in ipairs(v37:GetDescendants()) do
		if not (not v39:IsA("ParticleEmitter") and not v39:IsA("Beam") and not v39:IsA("Trail")) or v39:IsA("PointLight") then
			v39.Enabled = false;
		end;
	end;
end;
v3.EnabledAllVisuals = function(_, v41)
	for _, v43 in pairs(v41:GetDescendants()) do
		if not (not v43:IsA("ParticleEmitter") and not v43:IsA("Beam") and not v43:IsA("Trail")) or v43:IsA("PointLight") then
			v43.Enabled = true;
		end;
	end;
end;
v3.EmitAllParticles = function(_, v45)
	for _, v47 in ipairs(v45:GetDescendants()) do
		if v47:IsA("ParticleEmitter") then
			v47:Emit(v47.Rate);
		end;
	end;
end;
v3.ScaleParticles = function(_, v49, v50)
	for _, v52 in pairs(v49:GetDescendants()) do
		if v52:IsA("ParticleEmitter") then
			local v53 = {};
			for v54 = 1, #v52.Size.Keypoints do
				table.insert(v53, NumberSequenceKeypoint.new(v52.Size.Keypoints[v54].Time, v52.Size.Keypoints[v54].Value * v50, v52.Size.Keypoints[v54].Envelope));
			end;
			v52.Speed = NumberRange.new(v52.Speed.Min * v50, v52.Speed.Max * v50);
			v52.Acceleration = v52.Acceleration * v50;
			v52.Size = NumberSequence.new(v53);
			table.clear(v53);
		end;
	end;
end;
Lerp = function(v55, v56, v57)
	return v55 + (v56 - v55) * v57;
end;
v3.Lerp = function(_, v59, v60, v61)
	return v59 + (v60 - v59) * v61;
end;
v3.ReturnRandomAngle = function(_)
	return CFrame.Angles(v6:NextNumber(-360, 360), v6:NextNumber(-360, 360), v6:NextNumber(-360, 360));
end;
v3.ConvertNormalPosToCF = function(_, v64, v65)
	local l_UpVector_0 = CFrame.lookAt(v65, v65 + v64).UpVector;
	local v67 = l_UpVector_0:Cross(v64);
	return CFrame.fromMatrix(v65, -v67, v64, l_UpVector_0);
end;
v3.UnixConnection2 = function(_, v69, v70, v71, v72)
	local v73 = false;
	local v74 = false;
	local v75 = tick();
	v3:AddTempFunction(function(v76)
		v73 = not (v75 + v69 > tick());
		if v70 and (not (not v71 or not v71()) or v71 == nil) and not v73 then
			local v77 = (tick() - v75) / v69;
			local v78 = Lerp(1, 0, v77);
			v70(v77, v76, v78, tick() - v75);
			return;
		elseif not v74 then
			v74 = true;
			if v70 and v73 then
				v70(1, v76, 0, v69);
			end;
			if v72 then
				v72(1, v76, 0);
			end;
			return true;
		else
			return;
		end;
	end);
end;
v3.UnixConnection = function(_, v80, v81, v82, v83)
	local v84 = if l_RunService_0:IsClient() then l_RunService_0.RenderStepped else l_RunService_0.Heartbeat;
	local v85 = nil;
	local v86 = false;
	local v87 = os.clock();
	local v88 = false;
	v85 = v84:Connect(function(v89)
		if not v88 then
			v88 = true;
			v86 = not (v87 + v80 > os.clock());
			if v81 and (not (not v82 or not v82()) or v82 == nil) and not v86 then
				local v90 = (os.clock() - v87) / v80;
				local v91 = Lerp(1, 0, v90);
				v81(v90, v89, v91, os.clock() - v87);
			else
				v85:Disconnect();
				if v81 and v86 then
					v81(1, v89, 0, v80);
				end;
				if v83 then
					v83(1, v89, 0);
				end;
			end;
			v88 = false;
		end;
	end);
	return v85;
end;
v3.UnixWithFrequency = function(_, v93, v94, v95, v96)
	local v97 = os.clock();
	local v98 = if l_RunService_0:IsServer() then l_RunService_0.Heartbeat else l_RunService_0.RenderStepped;
	local l_v97_0 = v97;
	local v100 = nil;
	v100 = v98:Connect(function(_)
		local v102 = os.clock() - l_v97_0;
		if v94 < v102 then
			l_v97_0 = os.clock();
			v95((os.clock() - v97) / v93, v102);
		end;
		if v100 and v93 < os.clock() - v97 then
			v100:Disconnect();
			v100 = nil;
			if v96 then
				v96(1, v102);
			end;
		end;
	end);
end;
(if l_RunService_0:IsServer() then l_RunService_0.Heartbeat else l_RunService_0.RenderStepped):Connect(function(v103)
	for _, v105 in pairs(v4) do
		v105(v103);
	end;
	local _ = nil;
	for _, v108 in pairs(v5) do
		if v108.callback(v103) then
			table.remove(v5, table.find(v5, v108));
		end;
	end;
end);
return v3;

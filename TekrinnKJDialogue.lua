-- Awesome sauce

local l_CollectionService_0 = game:GetService("CollectionService");
local l_TextService_0 = game:GetService("TextService");
local l_LocalPlayer_0 = game.Players.LocalPlayer;
local v3 = {};
local _ = {
    {
        Text = "This will be the ", 
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), 
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 17, 17)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        }), 
        TextStrokeColor = Color3.new(0, 0, 0), 
        Bold = false, 
        Italic = false, 
        Shake = {
            Enabled = false, 
            Intensity = 1, 
            Lifetime = 2
        }, 
        TypeSpeed = 0.03
    }, 
    {
        Text = "LAST TIME!", 
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), 
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 17, 17))
        }), 
        TextStrokeColor = Color3.new(0, 0, 0), 
        Bold = true, 
        Italic = true, 
        Shake = {
            Enabled = true, 
            Intensity = 5, 
            Lifetime = 1
        }, 
        TypeSpeed = 0.04
    }
};
local function _(v5) --[[ Line: 54 ]] --[[ Name: easeOutQuad ]]
    return 1 + 2.70158 * math.pow(v5 - 1, 3) + 1.70158 * math.pow(v5 - 1, 2);
end;
getColor = function(v7, v8) --[[ Line: 61 ]] --[[ Name: getColor ]]
    local v9 = v8[1];
    local v10 = v8[#v8];
    local v11 = 0.5;
    local l_Value_0 = v9.Value;
    for v13 = 1, #v8 - 1 do
        if v8[v13].Time <= v7 and v7 <= v8[v13 + 1].Time then
            v9 = v8[v13];
            v10 = v8[v13 + 1];
            v11 = (v7 - v9.Time) / (v10.Time - v9.Time);
            return (v9.Value:lerp(v10.Value, v11));
        end;
    end;
    return l_Value_0;
end;
local function v17(v14) --[[ Line: 81 ]] --[[ Name: retireTexts ]]
    for _, v16 in v14:GetChildren() do
        if v16.Name == "letter" then
            v16:SetAttribute("Ending", true);
            game.TweenService:Create(v16, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = v16.Position + UDim2.new(0, 0, 0, 50), 
                TextTransparency = 1, 
                TextStrokeTransparency = 1
            }):Play();
            game.Debris:AddItem(v16, 0.5);
        end;
    end;
end;
local function v55(v18, v19) --[[ Line: 97 ]] --[[ Name: doText ]]
    v19 = v19 or l_LocalPlayer_0;
    local v20 = l_LocalPlayer_0.PlayerGui:FindFirstChild(v19.Name .. "KJUI") or game.ReplicatedStorage.Resources.UFW.TekrinnDialogue.KJDialogue:Clone();
    local v21 = "";
    local v22 = 0;
    local v23 = 0;
    local v24 = 0;
    if not v20:GetAttribute("Created") then
        local l_Template_0 = v20:WaitForChild("Holder"):WaitForChild("Template");
        local l_Holder_0 = v20.Holder;
        l_Holder_0.Position = l_Holder_0.Position - UDim2.new(0, 0, 0, 100 * #l_CollectionService_0:GetTagged("KJUI"));
        l_Holder_0 = l_Template_0:WaitForChild("ImageLabel");
        l_Holder_0.Position = l_Holder_0.Position - UDim2.new(0, 0, 0, 100);
        l_Template_0:WaitForChild("ImageLabel").ImageTransparency = 1;
        l_Holder_0 = l_Template_0:WaitForChild("Name");
        l_Holder_0.Position = l_Holder_0.Position - UDim2.new(0, 0, 0, 100);
        l_Template_0:WaitForChild("Name").TextTransparency = 1;
        l_Template_0:WaitForChild("Name").TextStrokeTransparency = 1;
        game.TweenService:Create(l_Template_0:WaitForChild("ImageLabel"), TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = l_Template_0:WaitForChild("ImageLabel").Position + UDim2.new(0, 0, 0, 100), 
            ImageTransparency = 0
        }):Play();
        game.TweenService:Create(l_Template_0:WaitForChild("Name"), TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = l_Template_0:WaitForChild("Name").Position + UDim2.new(0, 0, 0, 100), 
            TextTransparency = 0, 
            TextStrokeTransparency = 0
        }):Play();
        local l_l_Template_0_0 = l_Template_0 --[[ copy: 7 -> 25 ]];
        task.spawn(function() --[[ Line: 129 ]]
            v20:SetAttribute("Created", os.clock());
            repeat
                task.wait();
            until os.clock() - v20:GetAttribute("Created") > 5 or not v20.Parent;
            v20.Name = "deleting";
            v17(v20.Holder.Template);
            game.TweenService:Create(l_l_Template_0_0:WaitForChild("ImageLabel"), TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = l_l_Template_0_0:WaitForChild("ImageLabel").Position - UDim2.new(0, 0, 0, 100), 
                ImageTransparency = 1
            }):Play();
            game.TweenService:Create(l_l_Template_0_0:WaitForChild("Name"), TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Position = l_l_Template_0_0:WaitForChild("Name").Position - UDim2.new(0, 0, 0, 100), 
                TextTransparency = 1, 
                TextStrokeTransparency = 1
            }):Play();
            task.delay(1, function() --[[ Line: 148 ]]
                v20:Destroy();
            end);
        end);
    else
        v20:SetAttribute("Created", os.clock());
    end;
    v20.Parent = l_LocalPlayer_0.PlayerGui;
    v20.Enabled = true;
    v20.Name = v19.Name .. "KJUI";
    v20:AddTag("KJUI");
    v20:WaitForChild("Holder"):WaitForChild("Template"):WaitForChild("Name").Text = v19.Name;
    for _, v29 in v18 do
        v21 = v21 .. v29.Text;
    end;
    local v30 = false;
    for _, v32 in pairs(v18) do
        if v32.HigherUp then
            v30 = true;
            game:GetService("TweenService"):Create(v20.Holder, TweenInfo.new(0.2), {
                Position = UDim2.new(0.5, 0, 0.965, 0)
            }):Play();
        end;
    end;
    if not v30 and v20.Holder.Position ~= UDim2.new(0.5, 0, 1, 0) then
        game:GetService("TweenService"):Create(v20.Holder, TweenInfo.new(1), {
            Position = UDim2.new(0.5, 0, 1, 0)
        }):Play();
    end;
    v17(v20.Holder.Template);
    for _, v34 in v18 do
        local v35 = string.split(v34.Text, "");
        local v36 = v34.Bold and Enum.Font.SourceSansBold or v34.Italic and Enum.Font.SourceSansItalic or Enum.Font.SourceSans;
        for _, v38 in v35 do
            v22 = v22 + l_TextService_0:GetTextSize(v38, 25, v36, Vector2.new(100, 100)).X;
        end;
    end;
    for _, v40 in v18 do
        local v41 = string.split(v40.Text, "");
        local v42 = v40.Bold and Enum.Font.SourceSansBold or v40.Italic and Enum.Font.SourceSansItalic or Enum.Font.SourceSans;
        for _, v44 in v41 do
            local l_l_TextService_0_TextSize_0 = l_TextService_0:GetTextSize(v44, 25, v42, Vector2.new(100, 100));
            local l_TextLabel_0 = Instance.new("TextLabel");
            local l_v22_0 = v22;
            local l_v23_0 = v23;
            local _ = UDim2.new(0.5, l_v23_0 - l_v22_0 / 2 // 1, 0.5, 0);
            l_TextLabel_0.AnchorPoint = Vector2.new(0, 0.5);
            l_TextLabel_0.Position = UDim2.new(0.5, l_v23_0 - l_v22_0 / 2 // 1, 0.5, 10);
            l_TextLabel_0.Size = UDim2.new(0, l_l_TextService_0_TextSize_0.X, 0, l_l_TextService_0_TextSize_0.Y);
            l_TextLabel_0.Text = v44;
            l_TextLabel_0.Name = "letter";
            l_TextLabel_0.Font = v42;
            l_TextLabel_0.TextSize = 25;
            l_TextLabel_0.Parent = v20.Holder.Template;
            l_TextLabel_0.BackgroundTransparency = 1;
            l_TextLabel_0.TextStrokeColor3 = v40.TextStrokeColor;
            l_TextLabel_0.TextStrokeTransparency = 0;
            l_TextLabel_0.TextStrokeTransparency = 1;
            l_TextLabel_0.TextTransparency = 1;
            task.delay(v24, function() --[[ Line: 221 ]]
                local v50 = os.clock();
                repeat
                    local v51 = math.min((os.clock() - v50) / 0.35, 1);
                    local v52 = math.min((os.clock() - v50) / v40.Shake.Lifetime, 1);
                    local v53 = not v40.Shake.Enabled and UDim2.new(0, 0, 0, 0) or UDim2.new(0, math.random(-v40.Shake.Intensity, v40.Shake.Intensity) * (1 - v52), 0, math.random(-v40.Shake.Intensity, v40.Shake.Intensity) * (1 - v52));
                    local v54 = 1 - (1 + 2.70158 * math.pow(v51 - 1, 3) + 1.70158 * math.pow(v51 - 1, 2));
                    l_TextLabel_0.TextStrokeTransparency = (1 - v51) ^ 10;
                    l_TextLabel_0.TextTransparency = v54;
                    l_TextLabel_0.TextSize = 25 + 25 * v54;
                    l_TextLabel_0.TextColor3 = getColor(v51, v40.Color.Keypoints);
                    l_TextLabel_0.Position = UDim2.new(0.5, l_v23_0 - l_v22_0 / 2 // 1, 0.5, 0) + v53;
                    task.wait();
                until os.clock() - v50 > math.max(0.35, v40.Shake.Lifetime) or not l_TextLabel_0 or not l_TextLabel_0:IsDescendantOf(v20) or l_TextLabel_0:GetAttribute("Ending");
                if l_TextLabel_0 then
                    l_TextLabel_0.TextStrokeTransparency = 0;
                    l_TextLabel_0.TextTransparency = 0;
                    l_TextLabel_0.TextSize = 25;
                    l_TextLabel_0.TextColor3 = v40.Color.Keypoints[#v40.Color.Keypoints].Value;
                    l_TextLabel_0.Position = UDim2.new(0.5, l_v23_0 - l_v22_0 / 2 // 1, 0.5, 0);
                end;
            end);
            v24 = v24 + v40.TypeSpeed;
            v23 = v23 + l_l_TextService_0_TextSize_0.X;
        end;
    end;
end;
v3.Speak = function(v56, v57) --[[ Line: 273 ]]
    v55(v57, v56);
end;
return v3;

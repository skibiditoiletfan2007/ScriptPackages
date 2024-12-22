-- Not the original file for Maid. TSB's Library module has a modified one.

local v0 = {
    ClassName = "Maid"
};
v0.new = function() --[[ Line: 18 ]] --[[ Name: new ]]
    return (setmetatable({
        _tasks = {}
    }, v0));
end;
v0.isMaid = function(v1) --[[ Line: 24 ]] --[[ Name: isMaid ]]
    local v2 = false;
    if type(v1) == "table" then
        v2 = v1.ClassName == "Maid";
    end;
    return v2;
end;
v0.__index = function(v3, v4) --[[ Line: 30 ]] --[[ Name: __index ]]
    if v0[v4] then
        return v0[v4];
    else
        return v3._tasks[v4];
    end;
end;
v0.__newindex = function(v5, v6, v7) --[[ Line: 47 ]] --[[ Name: __newindex ]]
    if v0[v6] ~= nil then
        error(("'%s' is reserved"):format((tostring(v6))), 2);
    end;
    local l__tasks_0 = v5._tasks;
    local v9 = l__tasks_0[v6];
    if v9 == v7 then
        return;
    else
        l__tasks_0[v6] = v7;
        if v9 then
            if type(v9) == "function" then
                v9();
                return;
            elseif typeof(v9) == "RBXScriptConnection" then
                v9:Disconnect();
                return;
            elseif v9.Destroy then
                v9:Destroy();
                return;
            elseif v9.destroy then
                v9:destroy();
            end;
        end;
        return;
    end;
end;
v0.giveTask = function(v10, v11) --[[ Line: 77 ]] --[[ Name: giveTask ]]
    if not v11 then
        error("Task cannot be false or nil", 2);
    end;
    local v12 = #v10._tasks + 1;
    v10[v12] = v11;
    if type(v11) == "table" and not v11.Destroy and not v11.destroy then
        warn("[Maid.GiveTask] - Gave table task without .Destroy\n\n" .. debug.traceback());
    end;
    return v12;
end;
v0.give = function(v13, v14) --[[ Line: 109 ]] --[[ Name: give ]]
    local __ = nil;
    if type(v14) == "table" and v14.isAPromise then
        local v16, v17 = v13:givePromise(v14);
        _ = v16;
        return v14, v17;
    else
        return v14, (v13:giveTask(v14));
    end;
end;
v0.doCleaning = function(v18) --[[ Line: 121 ]] --[[ Name: doCleaning ]]
    local l__tasks_1 = v18._tasks;
    for v20, v21 in pairs(l__tasks_1) do
        if typeof(v21) == "RBXScriptConnection" then
            l__tasks_1[v20] = nil;
            v21:Disconnect();
        end;
    end;
    local v22, v23 = next(l__tasks_1);
    while v23 ~= nil do
        l__tasks_1[v22] = nil;
        if type(v23) == "function" then
            v23();
        elseif typeof(v23) == "RBXScriptConnection" then
            v23:Disconnect();
        elseif v23.Destroy then
            v23:Destroy();
        elseif v23.destroy then
            v23:destroy();
        end;
        local v24, v25 = next(l__tasks_1);
        v22 = v24;
        v23 = v25;
    end;
end;
v0.destroy = v0.doCleaning;
v0.clean = v0.doCleaning;
return v0;

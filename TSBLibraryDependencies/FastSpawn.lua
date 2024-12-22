-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

return function(v0, ...) --[[ Line: 5 ]]
    assert(type(v0) == "function");
    local v1 = {
        ...
    };
    local v2 = select("#", ...);
    local l_BindableEvent_0 = Instance.new("BindableEvent");
    l_BindableEvent_0.Event:Connect(function() --[[ Line: 12 ]]
        v0(unpack(v1, 1, v2));
    end);
    l_BindableEvent_0:Fire();
    l_BindableEvent_0:Destroy();
end;

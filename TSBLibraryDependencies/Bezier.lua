-- They really had to make this a seperate instance
local v0 = {};
Lerp = function(v1, v2, v3) --[[ Line: 3 ]] --[[ Name: Lerp ]]
    return v1 + (v2 - v1) * v3;
end;

v0.Quad = function(v4, v5, v6, v7) --[[ Line: 7 ]] --[[ Name: Quad ]]
    local v8 = Lerp(v4, v5, v7);
    local v9 = Lerp(v5, v6, v7);
    return Lerp(v8, v9, v7);
end;

return v0;

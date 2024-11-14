--!strict
--!nolint LocalUnused
--!nolint LocalShadow
local task = nil -- Disable usage of Roblox's task scheduler
--[[
	The entry point for the Fusion library.
]]

local Types = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Types.lua"))()
local External = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/External.lua"))()

type Fusion = Types.Fusion

export type Animatable = Types.Animatable
export type UsedAs<T> = Types.UsedAs<T>
export type Child = Types.Child
export type Computed<T> = Types.Computed<T>
export type Contextual<T> = Types.Contextual<T>
export type GraphObject = Types.GraphObject
export type For<KO, VO> = Types.For<KO, VO>
export type Observer = Types.Observer
export type PropertyTable = Types.PropertyTable
export type Scope<Constructors = Fusion> = Types.Scope<Constructors>
export type ScopedObject = Types.ScopedObject
export type SpecialKey = Types.SpecialKey
export type Spring<T> = Types.Spring<T>
export type StateObject<T> = Types.StateObject<T>
export type Task = Types.Task
export type Tween<T> = Types.Tween<T>
export type Use = Types.Use
export type Value<T, S = T> = Types.Value<T, S>
export type Version = Types.Version

-- Down the line, this will be conditional based on whether Fusion is being
-- compiled for Roblox.
do
	local RobloxExternal = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/RobloxExternal.lua"))()
	External.setExternalProvider(RobloxExternal)
end

local Fusion: Fusion = table.freeze {
	-- General
	version = {major = 0, minor = 3, isRelease = true},
	Contextual = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Utility/Contextual.lua"))(),
	Safe = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Utility/Safe.lua"))(),

	-- Memory
	cleanup = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Memory/legacyCleanup.lua"))(),
	deriveScope = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Memory/deriveScope.lua"))(),
	doCleanup = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Memory/doCleanup.lua"))(),
	innerScope = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Memory/innerScope.lua"))(),
	scoped = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Memory/scoped.lua"))(),
	
	-- Graph
	Observer = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Graph/Observer.lua"))(),

	-- State
	Computed = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/State/Computed.lua"))(),
	ForKeys = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/State/ForKeys.lua"))() :: Types.ForKeysConstructor,
	ForPairs = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/State/ForPairs.lua"))() :: Types.ForPairsConstructor,
	ForValues = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/State/ForValues.lua"))() :: Types.ForValuesConstructor,
	peek = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/State/peek.lua"))(),
	Value = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/State/Value.lua"))(),

	-- Roblox API
	Attribute = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Instances/Attribute.lua"))(),
	AttributeChange = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Instances/AttributeChange.lua"))(),
	AttributeOut = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Instances/AttributeOut.lua"))(),
	Child = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Instances/Child.lua"))(),
	Children = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Instances/Children.lua"))(),
	Hydrate = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Instances/Hydrate.lua"))(),
	New = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Instances/New.lua"))(),
	OnChange = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Instances/OnChange.lua"))(),
	OnEvent = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Instances/OnEvent.lua"))(),
	Out = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Instances/Out.lua"))(),
	
	-- Animation
	Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Animation/Tween.lua"))(),
	Spring = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/main/FusionDependencies/Animation/Spring.lua"))(),
}

return Fusion

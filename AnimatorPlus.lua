--!nocheck
--!optimize 2
--!native
-- @proxiom
local RunService = game:GetService("RunService")
local AnimationTrack = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/refs/heads/main/AnimatorPlusDependencies/AnimationTrack.lua"))()
local Types = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/refs/heads/main/AnimatorPlusDependencies/Types.lua"))()
local AnimationMode = {
	Combined = 0,
	Transform = 1,
	C0 = 2,
}
local Animator:Types.Module = {}
Animator.__index = Animator
Animator.AnimMode = AnimationMode.Combined
local function createTracker(object: Instance, propertyName: string, onSet: (string) -> (), onUnset: (string?) -> ())
	local currentValue: string?
	local propertyChangedConnection: RBXScriptConnection?
	local function onPropertyChanged(newValue: string?)
		onUnset(currentValue)
		currentValue = newValue
		onSet(currentValue)
	end
	local function updateValue()
		local property = object[propertyName]
		if property then
			currentValue = property.Name
			onSet(currentValue)
			if propertyChangedConnection then
				propertyChangedConnection:Disconnect()
			end
			propertyChangedConnection = property:GetPropertyChangedSignal("Name"):Connect(onPropertyChanged)
		else
			currentValue = nil
			onSet(currentValue)
		end
	end
	propertyChangedConnection = object:GetPropertyChangedSignal(propertyName):Connect(updateValue)
	return function()
		if propertyChangedConnection then
			propertyChangedConnection:Disconnect()
		end
	end
end
function Animator:GetPlayingAnimationTracks()
	local playingAnimations = {}
	for _, animation in (self._animations) do
		if animation.IsPlaying then
			table.insert(playingAnimations, animation.Name)
		end
	end
	return playingAnimations
end
function Animator:LoadAnimation(keyframeSequence: KeyframeSequence): Types.AnimationTrack
	for key, Keyframe in keyframeSequence:GetChildren() do
		if not Keyframe:IsA("Keyframe") then
			Keyframe:Destroy()
		end
	end
	for _, animation in (self._animations) do
		if animation._keyframeSequence == keyframeSequence then
			return animation
		end
	end
	local animation = AnimationTrack.new(self, keyframeSequence)
	table.insert(self._animations, animation)
	return animation
end
function Animator:Destroy()
	for _, stopTracker in (self._jointTrackers) do stopTracker() end
	self._animations = {}
	self._jointTrackers = {}
	self._stepped:Disconnect()
	self._descendantAdded:Disconnect()
	self._descendantRemoving:Disconnect()
	self._stepped = nil
	self._descendantAdded = nil
	self._descendantRemoving = nil
end
function Animator.new(humanoid: Humanoid): Types.Animator
	local self = setmetatable({}, Animator)
	self._animations = {}
	self._humanoid = humanoid
	self._joints = {}
	self._transforms = {}
	self._jointTrackers = {}
	self._stepped = RunService.Stepped:Connect(function(Time,deltaTime)
		local currentTransforms = self._transforms
		local joints = self._joints
		local newTransforms = {}
		local priorities = {}
		
		for jointName in (joints) do
			priorities[jointName] = 0
		end
		for _, animation in (self._animations) do
			if not animation._step then continue end
			local priority = animation.Priority.Value
			local transforms, weight = animation._step(Time,deltaTime)
			if not transforms then continue end
			for jointName, cf in (transforms) do
				if not joints[jointName] then continue end
				if priority > priorities[jointName] then
					priorities[jointName] = priority
					newTransforms[jointName] = {animation._startTime, cf, weight}
				elseif not newTransforms[jointName] or animation._startTime > newTransforms[jointName][1] then
					newTransforms[jointName] = {animation._startTime, cf, weight}
				end
			end
		end
		for jointName, cfData in (newTransforms) do
			local weight = cfData[3]
			newTransforms[jointName] = weight == 1 and cfData[2] or currentTransforms[jointName]:Lerp(cfData[2], weight)
		end
		for jointName, jointData in (joints) do
			local cf = newTransforms[jointName] or CFrame.new()
			local isTransformChanged = cf ~= currentTransforms[jointName]
	
			if Animator.AnimMode == AnimationMode.Transform then
				jointData.joint.Transform = cf
			elseif Animator.AnimMode == AnimationMode.C0 then
				jointData.joint.C0 = jointData.c0 * cf
			elseif Animator.AnimMode == AnimationMode.Combined then
				if isTransformChanged then
					jointData.joint.Transform = cf
				else
					jointData.joint.C0 = jointData.c0 * cf
				end
			end
		end
		self._transforms = newTransforms
	end)
	local function onJointDescendant(joint)
		if joint.ClassName == "Motor6D" then
			local jointData = {joint = joint, c0 = joint.C0}
			if joint.Part1 then
				self._joints[joint.Part1.Name] = jointData
				self._transforms[joint.Part1.Name] = CFrame.new()
			end
			self._jointTrackers[joint] = createTracker(joint, "Part1", function(name)
				self._joints[name] = jointData
				self._transforms[name] = self._transforms[name] or CFrame.new()
			end, function()
				self._joints[joint.Part1.Name] = nil
			end)
		end
	end
	self._descendantAdded = humanoid.Parent.DescendantAdded:Connect(onJointDescendant)
	self._descendantRemoving = humanoid.Parent.DescendantRemoving:Connect(function(joint)
		if joint.ClassName == "Motor6D" then
			if joint.Part1 then
				self._joints[joint.Part1.Name] = nil
			end
			self._jointTrackers[joint]()
			self._jointTrackers[joint] = nil
		end
	end)
	for _, joint in (humanoid.Parent:GetDescendants()) do
		onJointDescendant(joint)
	end
	return self
end
return Animator

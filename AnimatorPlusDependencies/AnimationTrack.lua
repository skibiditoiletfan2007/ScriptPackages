-- @proxiom
--!nocheck
--!optimize 2
--!native
local Types = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/refs/heads/main/AnimatorPlusDependencies/Types.lua"))()
local Signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/refs/heads/main/AnimatorPlusDependencies/Signal.lua"))()
local getLerpAlpha = loadstring(game:HttpGet("https://raw.githubusercontent.com/skibiditoiletfan2007/ScriptPackages/refs/heads/main/AnimatorPlusDependencies/easing.lua"))()
local AnimationTrack = {}
AnimationTrack.__index = AnimationTrack
function AnimationTrack:AdjustSpeed(speed)
	self.Speed = speed
end
function AnimationTrack:AdjustWeight(weight, fadeTime)
	self.Weight = weight
end
function AnimationTrack:GetMarkerReachedSignal(name)
	self._markerReachedSignals = self._markerReachedSignals or {}
	local event = self._markerReachedSignals[name]
	if not event then
		event = Signal.new("MarkerReached")
		self._markerReachedSignals[name] = event
	end
	return event
end
function AnimationTrack:GetTimeOfKeyframe(keyframeName)
	return self._keyframeTimes[keyframeName] or error("Keyframe not found: " .. keyframeName)
end
function AnimationTrack:Play(fadeTime:number, weight:number, speed:number)
	fadeTime = fadeTime or 0.1
	speed = speed or 1
	self.Speed = speed
	self.Weight = weight or 1
	if self.IsPlaying then return end
	self.IsPlaying = true
	self.TimePosition = 0
	local function step(time,deltaTime)
		local timePosition = self.TimePosition + deltaTime * self.Speed
		local weight = math.min(timePosition / (fadeTime * self.Speed), 1) * self.Weight
		if self.Length == 0 then
			for _, jointName in (self._jointNames) do
				self._transforms[jointName] = CFrame.identity
			end
			return self._transforms, weight
		end
		if timePosition > self.Length then
			if self.Looped then
				timePosition = timePosition % self.Length
				self._passedKeyframes = {}
				self._passedMarkers = {}
				self.DidLoop:Fire()
			else
				self.TimePosition = self.Length
				self:Stop(fadeTime)
				return
			end
		end
		self.TimePosition = timePosition
		for name, time in (self._keyframeTimes) do
			if timePosition >= time and not self._passedKeyframes[name] then
				self._passedKeyframes[name] = true
				self.KeyframeReached:Fire(name)
			end
		end
		for name, time in (self._markerTimes) do
			if timePosition >= time and not self._passedMarkers[name] then
				self._passedMarkers[name] = true
				local marker = nil
				for _, keyframe in (self._keyframeSequence:GetChildren()) do
					if keyframe.time == time then
						for _, m in (keyframe:GetMarkers()) do
							if m.Name == name then
								marker = m
								break
							end
						end
					end
					if marker then break end
				end
				if marker then
					self._markerReachedSignals[name]:Fire(marker.Value)
				end
			end
		end
		for _, jointName in (self._jointNames) do
			local poses = self._keyframes[jointName]
			if not poses or #poses <= 1 then continue end
			local poseIndex = self:_findPoseIndex(jointName, timePosition)
			local lastPose = poses[poseIndex]
			local nextPose = poses[poseIndex + 1]
			self._transforms[jointName] = nextPose and self:_interpolatePoses(lastPose, nextPose, timePosition) or lastPose.CFrame
		end
		return self._transforms, weight
	end
	self._step = step
end
function AnimationTrack:_findPoseIndex(jointName, timePosition)
	local poses = self._keyframes[jointName]
	local low = 1
	local high = #poses
	while low <= high do
		local mid = math.floor((low + high) / 2)
		if poses[mid].time < timePosition then
			low = mid + 1
		else
			high = mid - 1
		end
	end
	return math.max(1, low - 1)
end
function AnimationTrack:_interpolatePoses(lastPose, nextPose, timePosition)
	local dt = (timePosition - lastPose.time) / (nextPose.time - lastPose.time)
	return lastPose.CFrame:Lerp(nextPose.CFrame, getLerpAlpha(dt, nextPose.easingStyle, nextPose.easingDirection))
end
function AnimationTrack:_fadeOut(fadeTime:number)
	local initCFrames = table.clone(self._transforms)
	local elapsed = 0
	local a = 0
	
	local function step(time,deltatime)
		elapsed += deltatime * self.Speed
		a = math.min(elapsed / fadeTime, 1)
		if a == 1 then
			self.Ended:Fire()
			self._step = nil
			return
		end
		local newTransforms = {}
		for jointName, initCF in (initCFrames) do
			newTransforms[jointName] = initCF:Lerp(CFrame.identity, a)
		end
		self._transforms = newTransforms
		return newTransforms, 1
	end
	
	self._step = step
end
function AnimationTrack:Stop(fadeTime)
	if not self.IsPlaying then return end
	fadeTime = fadeTime or 0.5
	self.IsPlaying = false
	self.Stopped:Fire()
	self._step = nil
	self._startTime = nil
	if fadeTime > 0 then
		self:_fadeOut(fadeTime)
	else
		self.Ended:Fire()
	end
end
function AnimationTrack.new(parent, keyframeSequence)
	local keyframes = keyframeSequence:GetChildren()
	table.sort(keyframes, function(a, b) return a.time < b.time end)
	
	local self = setmetatable({}, AnimationTrack)
	self.IsPlaying = false
	self.Length = keyframes[#keyframes].Time
	self.Looped = keyframeSequence.Loop
	self.Speed = 1
	self.TimePosition = 0
	self.Priority = keyframeSequence.Priority
	self.Name = keyframeSequence.Name
	self.Weight = 1
	
	self.DidLoop = Signal.new("DidLoop")
	self.Ended = Signal.new("Ended")
	self.Stopped = Signal.new("Stopped")
	self.KeyframeReached = Signal.new("KeyframeReached")
	
	self._parent = parent
	self._keyframeSequence = keyframeSequence
	self._destroyed = false
	self._keyframes = {}
	self._keyframeTimes = {}
	self._markerTimes = {}
	self._jointNames = {}
	self._transforms = {}
	self._step = nil
	self._markerReachedSignals = {}
	self._passedKeyframes = {}
	self._passedMarkers = {}
	for _, keyframe in (keyframes) do
		local markers = keyframe:GetMarkers()
		local rootPose = keyframe:FindFirstChild("HumanoidRootPart")
		
		if markers then
			for _, marker in (markers) do
				self._markerTimes[marker.Name] = keyframe.time
			end
		end
		
		if not rootPose then continue end
		
		for _, pose in (rootPose:GetDescendants()) do
			if not pose:IsA("Pose") or pose.Weight <= 0 then continue end
			local poseKeyframes = self._keyframes[pose.Name]
			if not poseKeyframes then
				poseKeyframes = {}
				self._keyframes[pose.Name] = poseKeyframes
				self._transforms[pose.Name] = CFrame.identity
				table.insert(self._jointNames, pose.Name)
			end
			table.insert(poseKeyframes, {
				time = keyframe.Time, 
				CFrame = pose.CFrame, 
				easingDirection = pose.EasingDirection.Value, 
				easingStyle = pose.EasingStyle.Value
			})
		end
	end
	for _, jointKeyframes in (self._keyframes) do
		if self.Looped and #jointKeyframes > 1 then
			local last = table.clone(jointKeyframes[#jointKeyframes])
			last.time = last.time - self.Length
			table.insert(jointKeyframes, 1, last)
		end
	end
	return self
end
return AnimationTrack

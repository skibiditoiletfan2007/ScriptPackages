-- ceat_ceat
local TweenService = game:GetService("TweenService")
local round = math.round
local getValue = TweenService.GetValue
local easingDirections = Enum.EasingDirection:GetEnumItems()
local easingFuncs = {}
for _, poseEasingStyle in Enum.PoseEasingStyle:GetEnumItems() do
	if poseEasingStyle == Enum.PoseEasingStyle.Constant or poseEasingStyle == Enum.PoseEasingStyle.CubicV2 then
		continue
	end
	local directions = {}
	local easingStyle = Enum.EasingStyle[poseEasingStyle.Name]
	for _, direction in easingDirections do
		directions[direction.Value] = function(a)
			return getValue(TweenService, a, easingStyle, direction)
		end
	end
	easingFuncs[poseEasingStyle.Value] = directions
end
easingFuncs[Enum.PoseEasingStyle.Constant.Value] = {
	[0] = round,
	[1] = round,
	[2] = round,
}
local cubic = easingFuncs[Enum.PoseEasingStyle.Cubic.Value]
easingFuncs[Enum.PoseEasingStyle.CubicV2.Value] = table.clone(cubic)
cubic[0], cubic[1] = cubic[1], cubic[0] -- mimic the incorrectly reversed easing styles
-- (cubicv2 was made to fix this)
local function getLerpAlpha(a, poseEasingStyleValue, poseEasingDirectionValue)
	return easingFuncs[poseEasingStyleValue][poseEasingDirectionValue](a)
end
return getLerpAlpha

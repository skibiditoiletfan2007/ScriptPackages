--!strict
-- @proxiom
local Types = {}
type self = {
	AnimMode: number,
	_animations: {},
	_humanoid: Humanoid,
	_destroyed: boolean,
	_joints: {},
	_transforms: {},
	_jointTrackers: {},
	_stepped: RBXScriptConnection | nil,
	_descendantAdded: RBXScriptConnection | nil,
	_descendantRemoving: RBXScriptConnection | nil,
}
export type Module = { new: (humanoid: Humanoid) -> Animator }
export type Animator = {	
	AnimMode: number?;
	
	LoadAnimation: (self:Animator,keyframeSequence: KeyframeSequence) -> AnimationTrack;
	GetPlayingAnimationTracks: (self:Animator) -> {any};
	Destroy: (self:Animator) -> ();
}
export type AnimationTrack = {
	Play: (self:AnimationTrack, fadeTime:number?, weight:number?, speed:number?) -> ();
	Stop: (self:AnimationTrack, fadeTime:number?) -> ();
	AdjustSpeed: (self:AnimationTrack,speed:number?) -> ();
	AdjustWeight: (self:AnimationTrack,weight:number?,fadeTime:number?) -> ();
	GetMarkerReachedSignal: (self:AnimationTrack, name:string) -> RBXScriptSignal;
	
	Name: string?;
	Speed: number?;
	Weight: number?;
	Length: number?;
	IsPlaying: BoolValue;
	Looped: BoolValue;
	Priority: any?;
	DidLoop: RBXScriptSignal;
	Ended: RBXScriptSignal;
	Stopped: RBXScriptSignal;
	KeyframeReached: RBXScriptSignal;
}
return Types

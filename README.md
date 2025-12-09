# Layered animation player
Tired of messy animation trees? Is animation player not enough for you but animation tree is too complicated? Then this thingie is for you!

This addon can help you generate complicated animation trees with simple code.

Here is an example definition:
```gdscript
@tool
extends LayeredAnimPlayer

@onready var skeleton_3d: Skeleton3D = %Skeleton3D

const LAYER_LOCOMOTION = 0
const LAYER_HOLDBOX = 10
const LAYER_WAVE = 20
const LAYER_DIE = 30

func defineLayers():
	var LocomotionLayer := LayerBasic.new()
	LocomotionLayer.blendTimeIn = 0.0
	LocomotionLayer.blendTimeOut = 0.0
	LocomotionLayer.blendTimeBetween = 0.2
	LocomotionLayer.anims = {
		"Idle": {L_ANIM: "ExtraAnims/Idle"},
		"Jog": {L_ANIM: "ExtraAnims/Jog"},
		"Run": {L_ANIM: "ExtraAnims/Run"},
		"Fall": {L_ANIM: "ExtraAnims/Fall"},
	}
	addLayer(LAYER_LOCOMOTION, LocomotionLayer)
	
	
	var boneFilter := BoneFilter.new(self, skeleton_3d) # Makes it so only arms are animated by the 'hold box' animation
	boneFilter.enableBoneReqursive("clavicle.l")
	boneFilter.enableBoneReqursive("clavicle.r")
	
	var HoldBoxLayer := LayerBasic.new()
	HoldBoxLayer.blendTimeIn = 0.2
	HoldBoxLayer.blendTimeOut = 0.2
	HoldBoxLayer.anims = {
		"HoldBox": {L_ANIM:"ExtraAnims/HoldBox"},
	}
	HoldBoxLayer.bones = boneFilter.getBonesFinal()
	addLayer(LAYER_HOLDBOX, HoldBoxLayer)
	
	
	var boneFilter2 := BoneFilter.new(self, skeleton_3d) # Makes it so only the left arm is used for the waving animation
	boneFilter2.enableBoneReqursive("clavicle.l")
	
	var WaveLayer := LayerBasic.new()
	WaveLayer.anims = {
		"Wave": {L_ANIM:"ExtraAnims/Wave"},
	}
	WaveLayer.bones = boneFilter2.getBonesFinal()
	addLayer(LAYER_WAVE, WaveLayer)


	var DieLayer := LayerBasic.new() # Full body animation, overrides all previous layers when played because it's last
	DieLayer.anims = {
		"Die": {L_ANIM:"ExtraAnims/Die"},
	}
	addLayer(LAYER_DIE, DieLayer)

```

Which produces this animation tree:

https://github.com/user-attachments/assets/d3b4a2ba-7e48-4855-a2c9-9cbbc49286cd


https://github.com/user-attachments/assets/73d40a80-c670-4269-b75e-77a3a0a01ed3

Using it as simple as this:
```gdscript
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("act_wave")):
		var randomWaveSpeed:float = randf_range(1.0, 2.0)
		# The wave animation is not looped so it will automatically end
		layered_anim_player.playLayer(layered_anim_player.LAYER_WAVE, "Wave", randomWaveSpeed)
	
	if(Input.is_action_just_pressed("act_box")):
		isHoldingBox = !isHoldingBox
		box.visible = isHoldingBox
	
	if(isHoldingBox):
		layered_anim_player.playLayer(layered_anim_player.LAYER_HOLDBOX, "HoldBox")
	else:
		layered_anim_player.stopLayer(layered_anim_player.LAYER_HOLDBOX)
	
	if(Input.is_action_just_pressed("act_die")):
		# The die animation is not looped so it will automatically end
		layered_anim_player.playLayer(layered_anim_player.LAYER_DIE, "Die")
	
	#print(layered_anim_player.getCurrentAnimationLayer(layered_anim_player.LAYER_LOCOMOTION))
	
	if(Input.is_action_just_pressed("debug_hit")):
		skeleton_hit_modifier.applyHit("head", Vector3(randf_range(-1.0, 1.0),randf_range(-1.0, 1.0),randf_range(-1.0, 1.0)).normalized(), 5.0, 0.8)
	
	if(Input.is_action_just_pressed("debug_struggle_start")):
		skeleton_hit_modifier.startStruggle(0.5, 0.8, 0.4, 0.8)
	if(Input.is_action_just_pressed("debug_struggle_end")):
		skeleton_hit_modifier.stopStruggle()
```


As a bonus, I also threw in a procedural hit skeleton modifier that I made that can be used for easy procedurally-generated hit animations

https://github.com/user-attachments/assets/effa0e20-fcdb-4f18-a407-0f7c6ba4d87d

## Credits:

Godot Human For Scale by Jamsers https://github.com/Jamsers/Godot-Human-For-Scale

extends Node3D
@onready var skeleton_hit_modifier: SkeletonHitModifier = $root/Skeleton3D/SkeletonHitModifier
@onready var layered_anim_player: LayeredAnimPlayer = $LayeredAnimPlayer
@onready var box: MeshInstance3D = $root/Skeleton3D/BoneAttachment3D/Box

func _on_right_footstep():
	$"../../"._on_right_footstep()

func _on_left_footstep():
	$"../../"._on_left_footstep()

# Animation stuff

var isHoldingBox:bool = false

func _ready() -> void:
	box.visible = false

var jogAnim:float = 0.0
func playLocomotionAnim(anim:String, _speed:float):
	if(anim == "Idle" || anim == "Jog" || anim == "Run"):
		layered_anim_player.playLayer(layered_anim_player.LAYER_LOCOMOTION, "Move", _speed, false)
		if(anim == "Idle"):
			jogAnim = jogAnim * 0.8 # Do a proper tween here, I'm lazy
		elif(anim == "Jog"):
			jogAnim = 1.0-((1.0-jogAnim) * 0.9)
		elif(anim == "Run"):
			jogAnim = 2.0-((2.0-jogAnim) * 0.9)
		layered_anim_player.setBlend1DPos(layered_anim_player.LAYER_LOCOMOTION, "Move", jogAnim)
	else:
		layered_anim_player.playLayer(layered_anim_player.LAYER_LOCOMOTION, anim, _speed)

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
		#"head" "spine_01"
		skeleton_hit_modifier.applyHit("head", Vector3(randf_range(-1.0, 1.0),randf_range(-1.0, 1.0),randf_range(-1.0, 1.0)).normalized(), 5.0, 0.8)
	
	if(Input.is_action_just_pressed("debug_struggle_start")):
		#skeleton_hit_modifier.struggle_min_interval = 
		skeleton_hit_modifier.startStruggle(0.5, 0.8, 0.4, 0.8)
	if(Input.is_action_just_pressed("debug_struggle_end")):
		skeleton_hit_modifier.stopStruggle()
	

extends Node3D
@onready var skeleton_hit_modifier: SkeletonHitModifier = $root/Skeleton3D/SkeletonHitModifier
#@onready var layered_anim_player: LayeredAnimPlayer = $LayeredAnimPlayer
@onready var box: MeshInstance3D = $root/Skeleton3D/BoneAttachment3D/Box
@onready var dynamic_anim_tree: DynamicAnimTree = $DynamicAnimTree

#@export var animTest:AnimationNode

func _on_right_footstep():
	$"../../"._on_right_footstep()

func _on_left_footstep():
	$"../../"._on_left_footstep()

# Animation stuff

var isHoldingBox:bool = false

func _ready() -> void:
	box.visible = false
	dynamic_anim_tree.setTreeDef(load("res://addons/DynamicAnimTree/DynAnimTreeExample.gd").new())
#
#var jogAnim:float = 0.0
func playLocomotionAnim(anim:String, _speed:float):
	var theLocoLayer:DATBlend2DRun = dynamic_anim_tree.getB2Layer(1)
	
	#print(anim)
	#if(!theLocoLayer.enabled):
	#	theLocoLayer.play(0.0)
	if(true):
		if(anim == "Idle" || anim == "Jog" || anim == "Run"):
			#theLocoLayer.smoothing = 0.6

			theLocoLayer.playAnim(0, "Idle")
			theLocoLayer.playAnim(1, "Jog")
			theLocoLayer.playAnim(2, "Run")
			theLocoLayer.playAnim(3, "Idle")
			if(anim == "Idle"):
				theLocoLayer.setPos(Vector2(0.0, 0.0))
			if(anim == "Jog"):
				theLocoLayer.setPos(Vector2(0.0, 0.5))
			if(anim == "Run"):
				theLocoLayer.setPos(Vector2(0.0, 1.0))
		else:
			theLocoLayer.setPos(Vector2(0.0, 0.0))
			theLocoLayer.playAnim(0, anim)
			pass
	else:
		dynamic_anim_tree.getALayer(2).play(anim)
	
	#dynamic_anim_tree.getLayer(1).play(anim)
	#if(anim == "Idle" || anim == "Jog" || anim == "Run"):
	#	layered_anim_player.playLayer(layered_anim_player.LAYER_LOCOMOTION, "Move", _speed, false)
	#	if(anim == "Idle"):
	#		jogAnim = jogAnim * 0.8 # Do a proper tween here, I'm lazy
	#	elif(anim == "Jog"):
	#		jogAnim = 1.0-((1.0-jogAnim) * 0.9)
	#	elif(anim == "Run"):
	#		jogAnim = 2.0-((2.0-jogAnim) * 0.9)
	#	layered_anim_player.setBlend1DPos(layered_anim_player.LAYER_LOCOMOTION, "Move", jogAnim)
	#else:
	#	layered_anim_player.playLayer(layered_anim_player.LAYER_LOCOMOTION, anim, _speed)
#
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("act_wave")):
		var randomWaveSpeed:float = randf_range(1.0, 2.0)
		# The wave animation is not looped so it will automatically end
		#layered_anim_player.playLayer(layered_anim_player.LAYER_WAVE, "Wave", randomWaveSpeed)
		dynamic_anim_tree.getLayer(4).play("ExtraAnims/Wave", randomWaveSpeed, 0.25, true, false)
	#
	if(Input.is_action_just_pressed("act_box")):
		isHoldingBox = !isHoldingBox
		box.visible = isHoldingBox
		if(isHoldingBox):
			dynamic_anim_tree.getLayer(3).play("ExtraAnims/HoldBox", 1.0, 0.25)
		else:
			dynamic_anim_tree.getLayer(3).play("", 1.0, 0.25)
	#
	#if(isHoldingBox):
	#	layered_anim_player.playLayer(layered_anim_player.LAYER_HOLDBOX, "HoldBox")
	#else:
	#	layered_anim_player.stopLayer(layered_anim_player.LAYER_HOLDBOX)
	#
	if(Input.is_action_just_pressed("act_die")):
		dynamic_anim_tree.getLayer(6).play("ExtraAnims/Die", 1.0, 0.25, true)
		# The die animation is not looped so it will automatically end
		#layered_anim_player.playLayer(layered_anim_player.LAYER_DIE, "Die")
	#
	##print(layered_anim_player.getCurrentAnimationLayer(layered_anim_player.LAYER_LOCOMOTION))
	#
	if(Input.is_action_just_pressed("debug_hit")):
		#"head" "spine_01"
		#dynamic_anim_tree.getALayer(6).stop()
		skeleton_hit_modifier.applyHit("head", Vector3(randf_range(-1.0, 1.0),randf_range(-1.0, 1.0),randf_range(-1.0, 1.0)).normalized(), 5.0, 0.8)
	
	if(Input.is_action_just_pressed("debug_struggle_start")):
		#skeleton_hit_modifier.struggle_min_interval = 
		skeleton_hit_modifier.startStruggle(0.5, 0.8, 0.4, 0.8)
	if(Input.is_action_just_pressed("debug_struggle_end")):
		skeleton_hit_modifier.stopStruggle()

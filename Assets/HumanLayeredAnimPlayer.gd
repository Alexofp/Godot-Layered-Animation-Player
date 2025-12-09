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
	
	
	var boneFilter := BoneFilter.new(self, skeleton_3d)
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
	
	
	var boneFilter2 := BoneFilter.new(self, skeleton_3d)
	boneFilter2.enableBoneReqursive("clavicle.l")
	
	var WaveLayer := LayerBasic.new()
	WaveLayer.anims = {
		"Wave": {L_ANIM:"ExtraAnims/Wave"},
	}
	WaveLayer.bones = boneFilter2.getBonesFinal()
	addLayer(LAYER_WAVE, WaveLayer)


	var DieLayer := LayerBasic.new()
	DieLayer.anims = {
		"Die": {L_ANIM:"ExtraAnims/Die"},
	}
	addLayer(LAYER_DIE, DieLayer)

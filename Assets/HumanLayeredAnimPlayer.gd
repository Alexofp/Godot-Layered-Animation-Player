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
		"Move": LayerAnimBlend1D.create({
			0.0: LayerAnim.create("ExtraAnims/Idle"),
			1.0: LayerAnim.create("ExtraAnims/Jog"),
			2.0: LayerAnim.create("ExtraAnims/Run"),
		}),
		#"Idle": LayerAnim.create("ExtraAnims/Idle"),
		#"Jog": LayerAnim.create("ExtraAnims/Jog"),
		#"Run": LayerAnim.create("ExtraAnims/Run"),
		"Fall": LayerAnim.create("ExtraAnims/Fall"),
	}
	addLayer(LAYER_LOCOMOTION, LocomotionLayer)
	
	
	var boneFilter := BoneFilter.new(self, skeleton_3d)
	boneFilter.enableBoneReqursive("clavicle.l")
	boneFilter.enableBoneReqursive("clavicle.r")
	
	var HoldBoxLayer := LayerBasic.new()
	HoldBoxLayer.blendTimeIn = 0.2
	HoldBoxLayer.blendTimeOut = 0.2
	HoldBoxLayer.anims = {
		"HoldBox": LayerAnim.create("ExtraAnims/HoldBox"),
	}
	HoldBoxLayer.bones = boneFilter.getBonesFinal()
	addLayer(LAYER_HOLDBOX, HoldBoxLayer)
	
	
	var boneFilter2 := BoneFilter.new(self, skeleton_3d)
	boneFilter2.enableBoneReqursive("clavicle.l")
	
	var WaveLayer := LayerBasic.new()
	WaveLayer.anims = {
		"Wave": LayerAnim.create("ExtraAnims/Wave"),
	}
	WaveLayer.bones = boneFilter2.getBonesFinal()
	WaveLayer.comboLayers = 2
	addLayer(LAYER_WAVE, WaveLayer)


	var DieLayer := LayerBasic.new()
	DieLayer.anims = {
		"Die": LayerAnim.create("ExtraAnims/Die"),
	}
	addLayer(LAYER_DIE, DieLayer)

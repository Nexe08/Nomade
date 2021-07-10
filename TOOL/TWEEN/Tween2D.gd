extends Node2D


enum Ease_Type{EASE_IN,EASE_OUT,EASE_IN_OUT, EASE_OUT_IN}

enum  TransType {TRANS_LINEAR,TRANS_SINE,TRANS_QUINT,TRANS_QUART,TRANS_QUAD,TRANS_EXPO,TRANS_ELASTIC,TRANS_CUBIC,TRANS_CIRC,TRANS_BOUNCE,TRANS_BACK}

export var TweenParent: bool
export(NodePath) var object
export (String)var Property
export (Vector2)var InitialValue
export (Vector2)var FinalValue
export (float)var Duration
export (TransType)var TransitionType
export (Ease_Type)var EaseType
export (float)var Delay

onready var tween = $Tween

var parent = get_parent()



func _physics_process(delta: float) -> void:
	if TweenParent == true:
		object = parent
	
	if object:
		tween.interpolate_property(object, Property, InitialValue, FinalValue, Duration * delta, TransitionType, EaseType, Delay)
	else:
		printerr("You Dumb, Fool, Noob, Object is not Defined")

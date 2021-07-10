extends KinematicBody2D

var _can_block: = false
export var life: int = 20
export var turn_duration: = 0.5
var _on_left: bool
var _on_right: bool
var _target
onready var _helth_bar = $Visual/HealthBar


func _ready() -> void:
	_helth_bar.value = 0
	_helth_bar.max_value = life



# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	_helth_bar.value = life
	if life <= 0:
		queue_free()
	else:
		if _target:
			_check_target_direction()
			_change_direction()
		else:
			_reset()



func take_damage(value):
	if _can_block:
		pass
	else:
		life -= value



# reset flegs to default
# or enemy state @not implemented yet
func _reset():
	_on_left = false
	_on_right = false



func _change_direction():
	var d = $player_projectile_detector
	if _on_left:
		d.rotation_degrees = 180
	if _on_right:
		d.rotation_degrees = 0



func _check_target_direction():
	# enable and desable target detector
	# if target detected then enable oposite and desable self
	if _target_detected_on_left():
		$target_detector/left.set_enabled(false)
		$target_detector/right.set_enabled(true)
		yield(get_tree().create_timer(turn_duration),"timeout")
		_on_left = true
		_on_right = false
	elif _target_detected_on_right():
		$target_detector/left.set_enabled(true)
		$target_detector/right.set_enabled(false)
		yield(get_tree().create_timer(turn_duration),"timeout")
		_on_right = true
		_on_left = false



func _target_detected_on_left():
	return $target_detector/left.is_colliding()



func _target_detected_on_right():
	return $target_detector/right.is_colliding()



# warning-ignore:unused_argument
func _on_player_projectile_body_entered(body: Node) -> void:
	_can_block = true



# warning-ignore:unused_argument
func _on_player_projectile_body_exited(body: Node) -> void:
	_can_block = false



func _on_target_detected_in_area(target) -> void:
	_target = target


func _on_target_detector_target_not_in_area() -> void:
	_target = false

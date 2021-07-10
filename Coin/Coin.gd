extends KinematicBody2D
class_name Coin

const MAX_SPEED := 500
const ACCEL := 500
var velocity := Vector2.ZERO
var player = Global.Player
var apply_force := false

onready var spawn_position = global_position


func _physics_process(delta: float) -> void:
	atrection_force(delta)
	velocity = move_and_slide(velocity)


func atrection_force(delta):
	if apply_force:
		var dir = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(dir * MAX_SPEED, ACCEL * delta)


func _on_PlayerDetector_body_entered(body: Node) -> void:
		if has_method("pickup_coin"):
			body.pickup_coin()
		queue_free()


func _on_waitTimer_timeout() -> void:
	apply_force = true

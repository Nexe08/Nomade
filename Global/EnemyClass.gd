extends KinematicBody2D
class_name EnemyClass

const UP := Vector2.UP

var _gravity := 800 
var apply_gravity := false

var velocity := Vector2.ZERO



func _physics_process(delta: float) -> void:
	if apply_gravity:
		velocity.y += _gravity * delta
	velocity = move_and_slide(velocity, UP)

extends RigidBody2D


var damage = 1
var speed = 500



func _on_body_entered(body):
	if not body.is_in_group("enemy_group"):
		set_sleeping(true)
		$Sprite.visible = false
		$CollisionShape2D.call_deferred("set_disabled", true)
		$AnimatedSprite.play("hit")
	
	if body.has_method("take_damage"):
		body.take_damage(damage)



func _on_animation_finished() -> void:
	queue_free()



func _on_destroy_timer_timeout() -> void:
	queue_free()

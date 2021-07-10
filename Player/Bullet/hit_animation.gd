extends AnimatedSprite


func _ready() -> void:
	pass


func _on_animation_finished() -> void:
	queue_free()

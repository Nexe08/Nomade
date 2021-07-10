extends CPUParticles2D


func _direction(value):
	var dir = Vector2(-value, 0)
	set_direction(dir)

extends AudioStreamPlayer2D


func _ready() -> void:
	randomize()


func _process(_delta: float) -> void:
	randomize_pitch()


func randomize_pitch():
	var pitch_scale_value = randf()
	
	if pitch_scale_value < 0.3:
		pitch_scale = 0.7
		
	elif pitch_scale_value >= 0.3 and pitch_scale_value < 0.7:
		pitch_scale = 0.9
		
	else:
		pitch_scale = 1


func _on_Hit_wallSFX_finished() -> void:
	queue_free()

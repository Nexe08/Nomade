extends Particles2D


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if not emitting:
		queue_free()
	

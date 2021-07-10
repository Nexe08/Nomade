extends Sprite


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta: float) -> void:
	if Global.Player.life > 0:
		global_position = get_global_mouse_position() 
	else:
		visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

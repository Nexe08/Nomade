extends Node2D



# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	print_FPS()


func print_FPS():
	$CanvasLayer/FPS.text = String(Performance.get_monitor(Performance.TIME_FPS))


func _on_restart_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

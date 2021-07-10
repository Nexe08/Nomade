extends Node2D

signal target_detected_in_area(target)
signal target_not_in_area


func _on_in_area_body_entered(body: Node) -> void:
	emit_signal("target_detected_in_area", body)


func _on_in_area_body_exited(_body: Node) -> void:
	emit_signal("target_not_in_area")

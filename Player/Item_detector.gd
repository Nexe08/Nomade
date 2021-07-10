extends Area2D

var item
var item_type
var _can_pick_up: bool = false


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pickup"):
		if _can_pick_up:
			if item:
				if item.has_method("pick_up"):
					item.pick_up(self)
					if item.has_method("get_item_type"): # assign item type if item is picked up
						item_type = item.get_item_type()
					get_parent().weapon_system.add_weapon(item_type)



func _on_Item_detector_body_entered(body: Node) -> void:
	item = body
	_can_pick_up = true


# warning-ignore:unused_argument
func _on_Item_detector_body_exited(body: Node) -> void:
	_can_pick_up = false

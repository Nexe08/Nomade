extends FSM



func _ready() -> void:
	add_state("non")
	add_state("dash")
	add_state("shoot")
	call_deferred("set_state", states.non)



func _state_logic(_delta):
	if parent.life > 0:
		# render dash trail
		if states.dash == state:
			parent.create_dash_trail(true)
		else:
			parent.create_dash_trail(false)
		
		# Muzzel flash
		if states.shoot == state:
			if not parent.State.states.jump == parent.State.state:
				parent.muzzel_flash.play("default")
		else:
			parent.muzzel_flash.play("empty")
			
		visualize()
		parent.attack_logic()
		
		# if not jumping then shoot
		if states.shoot == state:
			if not parent.State.states.jump == parent.State.state:
				parent.attack()
				
		# applying dash and dash logics
		parent.check_dash_posibility()
		parent.apply_dash()
		
		if states.dash == state:
			parent.speed.x = parent.DASH_SPEED
	else:
		# stop muzzel animation on death
		if states.shoot == state:
			parent.muzzel_flash.play("empty")



func _get_transition(_delta):
	if parent.life > 0:
		match state:
			states.non:
				if Input.is_action_pressed("shoot"):
					return states.shoot
				elif not parent._velocity.x == 0:
					if parent.on_dash:
						return states.dash
			states.shoot:
				if Input.is_action_just_released("shoot"):
					return states.non
				elif parent.on_dash:
					return states.dash
			states.dash:
				if not parent.on_dash:
					return states.non


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _enter_state(new_state, old_state):pass



# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _exit_state(old_state, new_state):pass



func visualize():
	if parent.life > 0:
		if states.non == state:
			parent.set_visual_attack_state("non")
		if states.shoot == state:
			parent.set_visual_attack_state("shoot")
		if states.dash == state:
			parent.set_visual_attack_state("dash")

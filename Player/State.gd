extends FSM


func _ready() -> void:
	add_state("idle")
	add_state("walk_left")
	add_state("walk_right")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", states.idle)



# this methode is to make _state_logic methode cleaner
func movement():
#	var direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	# horizontal--------------------
	parent.horizontal_movement()
	
	if [states.walk_left, states.walk_right, states.jump, states.fall].has(state):
		parent.speed.x = parent.MAX_SPEED
	# vertical-----------------------
	parent.jump_forgiveness()
	parent.vertical_movement()



func apply_gravity():
	# apply gravity
	if parent.AttackState.states.dash == parent.AttackState.state:
		parent.gravity = parent.DASH_GRAVITY
	else:
		parent.gravity = parent.IDLE_GRAVITY



### like _process method
func _state_logic(_delta):
	if parent.life > 0:
		parent._update(_delta)
		if states.jump == state:
			parent.jump_partical(true)
		else:
			parent.jump_partical(false)
		
		if not parent.on_dash:
			parent._velocity.x = clamp(parent._velocity.x, -parent.MAX_SPEED, parent.MAX_SPEED)
		elif parent.on_dash:
			parent._velocity.x = clamp(parent._velocity.x, -parent.DASH_SPEED, parent.DASH_SPEED)
		
		movement()
		visualis_state()
	else:
		parent.jump_partical(false)
		parent.self_distruction()
		parent._velocity.x = 0
		
	parent._velocity.y += parent.gravity * get_physics_process_delta_time()
	parent._velocity = parent.move_and_slide(parent._velocity, parent.UP)
	apply_gravity()



# responsibel for changing state
func _get_transition(_delta):
	match state:
		states.idle:
			if parent.is_on_floor():
				if parent.direction() < 0:
					return states.walk_left
					
				if parent.direction() > 0:
					return states.walk_right
					
			else:
				if parent._velocity.y > 0:
					return states.fall
					
				elif parent._velocity.y < 0:
					return states.jump
					
		states.walk_left:
			if parent.is_on_floor():
				if parent.direction() == 0:
					return states.idle
					
				elif parent.direction() > 0:
					return states.walk_right
			else:
				if parent._velocity.y > 0:
					return states.fall
					
				elif parent._velocity.y < 0:
					return states.jump
					
		states.walk_right:
			if parent.is_on_floor():
				if parent.direction() == 0:
					return states.idle
					
				elif parent.direction() < 0:
					return states.walk_left
			else:
				if parent._velocity.y > 0:
					return states.fall
					
				elif parent._velocity.y < 0:
					return states.jump
					
		states.jump:
			if parent.is_on_floor():
				return states.idle
				
			elif parent._velocity.y > 0:
				return states.fall
				
		states.fall:
			if parent.is_on_floor():
				return states.idle
				
			elif parent._velocity.y < 0:
				return states.jump
				
	return null



# warning-ignore:unused_argument
# do thing in start of the state
func _enter_state(new_state, old_state):
	if parent.life > 0:
		match new_state:
			
			states.jump:
				parent.pitch_randomizer()
				parent.jump_sfx.play()
				parent.fsm.travel("jump")
				
			states.fall:
				parent.fsm.travel("fall")
				
			states.walk_left:
				parent.fsm.travel("walk_left")
				
			states.walk_right:
				parent.fsm.travel("walk_right")
				
			states.idle:
				parent.fsm.travel("idle")



# warning-ignore:unused_argument
# do thing in end of the state
func _exit_state(old_state, new_state):
	if parent.life > 0:
		match old_state:
			
			states.fall:
				parent.emmit_fall_partical()


# show state (debug purpos)
func visualis_state():
	if state == states.idle:
		parent.set_visual_state("idle")
		
	if states.walk_left == state:
		parent.set_visual_state("walk_left")
		
	if states.walk_right == state:
		parent.set_visual_state("walk_right")
		
	if state == states.jump:
		parent.set_visual_state("jump")
		
	if state == states.fall:
		parent.set_visual_state("fall")

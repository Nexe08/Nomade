extends KinematicBody2D

# inform and give's the data to player helth bar
signal damaged(life)

### const value
const ACCELERATION = 7
const DEACCELERATION = 8
const IDLE_GRAVITY = 2100
const MAX_SPEED = 200
const DASH_TIME = 0.15
const DASH_SPEED = 1000
const DASH_GRAVITY = 800
const JUMP_SPEED = - 36000
const UP = Vector2.UP
### modifiable value
var life = 3
var gravity: int
var speed = Vector2(0, 0) # x = horzontal speed : y = virtical speed
var climb_speed = Vector2(100, 100)
var fire_rate = 0.2

var _velocity = Vector2.ZERO
var _jump_count: int = 2
var _max_velocity = 800
onready var _position = $PlayerBodyPart/chest.global_position
#### Flage
var on_walk: bool = false
var can_dash: bool = true
var on_dash: bool = false
var _can_shoot: bool = true
var _is_shooting: bool = false
var _is_climbing: bool = false
var IS_GROUNDED: bool = false
var IS_SHAKE: bool = false
#### Weapon Node
onready var _muzzel_ = $Weapon/Muzzle
onready var muzzel_flash = $Weapon/muzzel_flash
#### Animation Node
onready var animation_tree = $_anims_FSM
onready var fsm = animation_tree.get("parameters/playback")
#### SFX
onready var jump_sfx = $jumpSFX
#### camera
onready var camera = $Camera2D
#### State Node
onready var State = $State
onready var AttackState = $AttackState



func _ready():
	randomize()
	Global.Player = self



# physics process methode
func _update(_delta):
	_position = $PlayerBodyPart/chest.global_position
	$Camera2D.global_position.x = $Weapon/camera_position.global_position.x



func self_distruction():
	collision_layer = 1
	fsm.travel("dead")



func pitch_randomizer():
	var rand = randf()
	if rand <= 0.4:
		$jumpSFX.pitch_scale = 1.2
	elif rand > 0.4 and rand <= 0.7:
		$jumpSFX.pitch_scale = 1
	else:
		$jumpSFX.pitch_scale = 1.2



# FIX: make this func more readble and fast but befor that checke func speed
func attack():
	var _weapon_ = $Weapon
	if _can_shoot:
		$Fire_rate.start() # start fire rate timer
		_is_shooting = true
		var bullet = Global.Player_bullet.instance() #$Wapon_system.current_weapon
		bullet.position = _muzzel_.get_global_position()
		bullet.rotation_degrees = _weapon_.rotation_degrees
		bullet.apply_impulse(Vector2.ZERO, Vector2(bullet.speed, 0).rotated(_weapon_.rotation))
		get_parent().add_child(bullet)
		emmit_shoot_partical()
		$Camera2D.start(0.2, 20, 0.8)
		_can_shoot = false



func attack_logic():
	$Weapon.look_at(get_global_mouse_position())



func set_visual_state(_name):
	$CanvasLayer/STATE_VISUAL.text = _name



func set_visual_attack_state(_name):
	$CanvasLayer/attack_state.text = _name



func jump_forgiveness():
	if is_on_floor():
		IS_GROUNDED = true
	elif not is_on_floor():
		yield(get_tree().create_timer(0.1), "timeout")
		IS_GROUNDED = false



func vertical_movement():
	if IS_GROUNDED:
		if Input.is_action_just_pressed("jump"):
			_velocity.y = JUMP_SPEED * get_physics_process_delta_time()



func horizontal_movement():
	if direction() < 0:
		$_sprite.flip_h = true
	elif direction() > 0:
		$_sprite.flip_h = false
	if not on_dash:
		var dt = get_physics_process_delta_time()
		
		# friction on start
		if direction() > 0:
			_velocity.x += (MAX_SPEED * ACCELERATION * dt)
		elif direction() < 0:
			_velocity.x -= (MAX_SPEED * ACCELERATION * dt)
		else:
			
			if is_on_floor(): # friction on stop
				
				if _velocity.x < 0:
					_velocity.x += DEACCELERATION * MAX_SPEED * dt
					
					if _velocity.x >= 0:
						_velocity.x = 0
						
				elif _velocity.x > 0:
					_velocity.x -= DEACCELERATION * MAX_SPEED * dt
					
					if _velocity.x <= 0:
						_velocity.x = 0
			else:
				_velocity.x = 0
				
	elif on_dash:
		_velocity.x = DASH_SPEED * direction()



func emmit_shoot_partical():
	var spark = Global.player_shoot_partical.instance()
	spark.global_position = $Weapon/Muzzle.global_position
	spark.rotation_degrees = $Weapon.rotation_degrees
	get_parent().add_child(spark)
	spark.emitting = true



func jump_partical(value):
	$JumpPartical.emitting = value



func emmit_fall_partical():
	$FallPartical.emitting = true
	yield(get_tree().create_timer(0.5), "timeout")
	$FallPartical.emitting = false



func create_dash_trail(value):
	$Dashartical.emitting = value



### check if can dash
func check_dash_posibility():
	if is_on_floor():
		if $DashCooldownTimer.is_stopped():
			can_dash = true



### called in attack state machine
func apply_dash():
	if can_dash:
		if Input.is_action_just_pressed("dash"):
			on_dash = true
			yield(get_tree().create_timer(DASH_TIME), "timeout")
			on_dash = false
			can_dash = false
			$DashCooldownTimer.start()



### call in attacking node
func take_damage(_damage):
	fsm.travel("hit")
	life -= _damage
	_velocity.x *= 0.7
	emit_signal("damaged", life)



# set weapon icon in ui
func get_weapon_icon():
	var slote = [
		$CanvasLayer/Weapon_Slote/Container/Slote_1/sprite,
		$CanvasLayer/Weapon_Slote/Container/Slote_2/sprite
	]
	return slote



### identify droped weapon type
func get_weapon_type():
	var item_name = $Weapon_detector.item_name
	if item_name:
		return item_name



### based on input
func direction():
	return Input.get_action_strength("right") - Input.get_action_strength("left")



func real_position():
	return $PlayerBodyPart/chest.global_position



#func _physics_process(delta):
	# climb lader or other climbable object=============================
#	if _is_climbing:
#		# VERTICAL 
#		if Input.is_action_pressed("jump"):
#			_velocity.y = -climb_speed.y
#		else:
#			_velocity.y = climb_speed.y
#		# friction in lader
#		if direction() != 0:
#			_velocity.x *= 0.9
#===========================================================================



func _on_Fire_rate_timeout():
	_can_shoot = true



func _on_area_tile_detector_body_entered(body: Node) -> void:
	if body.is_in_group("Lader_group"):
		_is_climbing = true



func _on_area_tile_detector_body_exited(body: Node) -> void:
	if body.is_in_group("Lader_group"):
		_is_climbing = false

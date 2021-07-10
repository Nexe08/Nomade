extends EnemyClass


export var life = 10
export var bullet_speed := 200.0
export var rotation_speed := 5.0
var target

onready var animation_tree = $AnimationTree
onready var fsm = animation_tree.get("parameters/playback")
onready var _helth_bar = $Visual/HealthBar



func _ready() -> void:
	_helth_bar.value = 0
	_helth_bar.max_value = life
	apply_gravity = true



func _physics_process(delta: float) -> void:
	_helth_bar.value = life
	var tar_dir = $TargetDirection
	$Weapon.rotation = lerp_angle($Weapon.rotation, tar_dir.rotation, delta * rotation_speed)
	if not life == 0:
		if target: # if target is in range
			tar_dir.look_at(target._position)
			
			# need to ait until player in line of sight
			fsm.travel("shoot")
		else:
			tar_dir.rotation_degrees = 270
			fsm.travel("default")
	else:
		# on death
#		spawn_coin()
		queue_free()



func take_damage(value):
	life -= value



func spawn_coin():
	var coin = Global.Coin.instance()
	coin.global_position = global_position
	get_parent().add_child(coin)



# called in animation FSM
func StartAnticipation():
	if target:
		$Anticipation.play()



# this func is called in animation player
func shoot() -> void:
	if $Weapon/AimDirection.is_colliding():
		var bullet = Global.Enemy_bullet.instance()
		bullet.global_position = $Weapon/MuzzelPosition.global_position
		bullet.rotation_degrees = $Weapon/MuzzelPosition.rotation_degrees
		bullet.apply_impulse(Vector2.ZERO, Vector2(bullet_speed, 0).rotated($Weapon.rotation))
		get_parent().add_child(bullet)



func _on_Target_body_entered(body: Node) -> void:
	target = body



func _on_Target_body_exited(body: Node) -> void:
	if target == body:
		target = null


func _on_AnticipationSFX_finished() -> void:
	pass
#	$Anticipation.stop()

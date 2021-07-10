extends RigidBody2D
class_name Bullet

export var damage: float
export var speed: float

onready var trail = $trail
onready var target = self

var colliding_object

var point
var trail_length = 15


func _ready() -> void:
	randomize()
	randomize_pitch()


func _physics_process(_delta: float) -> void:
	render_trail()
	if colliding_object:
		if not $Hit_partical.emitting:
			queue_free()	

func render_trail():
	trail.global_position = Vector2.ZERO
	trail.global_rotation = 0
	point = target.global_position
	trail.add_point(point)
	if trail.get_point_count() > trail_length:
		trail.remove_point(0)


# SFX
func randomize_pitch():
	var pitch_scale_value = randf()
	
	if pitch_scale_value < 0.3:
		$FireSFX.pitch_scale = 0.7
		
	elif pitch_scale_value >= 0.3 and pitch_scale_value < 0.7:
		$FireSFX.pitch_scale = 0.9
		
	else:
		$FireSFX.pitch_scale = 1


func self_destruction():
	$Hit_partical.emitting = true
	$trail_partical.emitting = false
	set_sleeping(true)
	$Sprite.visible = false
	$Glow.visible = false
	$CollisionShape2D.call_deferred("set_disabled", true)


func play_hit_SFX_and_ANIMATION():
	#IDIA: this methode will expect on argument
	# whear argument will represent colliding area or body's group
	# and play sound and animation based on it
	var pos = global_position
	var hit_sfx = preload("res://Player/Bullet/Hit_wallSFX.tscn").instance()
	var hit_anim = preload("res://Player/Bullet/hit_animation.tscn").instance()
	
	hit_sfx.global_position = pos
	hit_anim.global_position = pos
	get_parent().add_child(hit_sfx)
	get_parent().add_child(hit_anim)
	hit_sfx.play()
	hit_anim.play("default")


func exit_the_screen() -> void:
	queue_free()


# contect with any area type
func collision_with_area(area: Area2D) -> void:
	colliding_object = area
	play_hit_SFX_and_ANIMATION()
	self_destruction()
		
	if area.has_method("take_damage"):
		area.take_damage(damage)
	

func _body_enterd(body: Node) -> void:
	colliding_object = body
	play_hit_SFX_and_ANIMATION()
	self_destruction()
	
	if body.has_method("take_damage"):
		body.take_damage(damage)


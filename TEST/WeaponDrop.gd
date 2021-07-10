extends KinematicBody2D
class_name Weapon_drop


var weapon_type
var Name
var damage
var speed
var fire_rate
var life_time
var projectile_texture
var icon_texture
var drop_texture

onready var sprite = $Sprite
onready var life_timer = $LifeTimer


func Drop(type):
	weapon_type = load(type)
	Name = weapon_type.Name
	damage = weapon_type.damage
	speed = weapon_type.speed
	fire_rate = weapon_type.fire_rate
	life_time = weapon_type.life_time
	projectile_texture = weapon_type.projectile_texture
	icon_texture = weapon_type.icon_texture
	drop_texture = weapon_type.drop_texture
	sprite.texture = weapon_type.drop_texture

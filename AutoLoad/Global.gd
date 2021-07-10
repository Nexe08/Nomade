extends Node

var Player = null
var Player_holded_weapon = null
var Player_secound_weapon = null
var camera = null

###################  Partical  ##############################
var player_shoot_partical: PackedScene = preload("res://Player/ShootPartical.tscn")

###################  Projectile  ##############################
var Player_bullet: PackedScene = preload("res://Player/Bullet/BULLET.tscn")
var Enemy_bullet: PackedScene = preload("res://game_object/projectile/Enemy_bullet.tscn")

###################  Drop/Pickeble Object  ##############################
var Coin: PackedScene = preload("res://Coin/Coin.tscn")

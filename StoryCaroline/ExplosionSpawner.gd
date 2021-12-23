extends Node2D

const Explosion = preload("res://Shoot.tscn")

onready var ExplosionPoints = $ExplosionPoints

func get_explosion_position():
	var points = ExplosionPoints.get_children()
	points.shuffle()
	return points[0].global_position
	
func spawn_explosion():
	var spawn_position = get_explosion_position()
	var explosion = Explosion.instance()
	var main = get_tree().current_scene
	main.add_child(explosion)
	explosion.global_position = spawn_position

func _on_Timer_timeout():
	spawn_explosion()

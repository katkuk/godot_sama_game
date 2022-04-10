extends Node2D

func _ready():
	pass

func playSound(soundNode : String):
	get_node(soundNode).play()

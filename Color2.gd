extends Node2D

signal colorChanged

func _ready():
	pass # Replace with function body.

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.is_pressed():
		print("i have been clicked")
		emit_signal("colorChanged")
		#self.get_child(0).self_modulate

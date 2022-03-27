extends Area2D

signal colorChanged
var myColor

func _ready():
	pass # Replace with function body.
	myColor = self.get_child(0).self_modulate

func _on_Color_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.is_pressed():
		emit_signal("colorChanged", myColor)
		

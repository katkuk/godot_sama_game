extends Node2D

var pressed = false
var active_line

func _ready():
	pass # Replace with function body.


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			print("clicked")
			pressed = true
			active_line = Line2D.new()
			active_line.default_color = Color("#ff3402")
			active_line.width = 10.0
		else:
			pressed = false
			
	if event is InputEventMouseMotion:
		if pressed:
			print("clicked2")
			active_line.add_point(event.position)
			add_child(active_line)
			

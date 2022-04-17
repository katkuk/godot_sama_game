extends Node2D
export(String) var GUIColorHex

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSound.stopSound("Thunder")
	GlobalSound.playSound("Snoring")


func _on_Sheep5_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Jump")
			get_node("Sheep5/AnimationPlayer").play("jump")


func _on_Sheep3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Jump")
			get_node("Sheep3/AnimationPlayer").play("jump")


func _on_Sheep1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Jump")
			get_node("Sheep1/AnimationPlayer").play("jump")


func _on_Sheep2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Jump")
			get_node("Sheep2/AnimationPlayer").play("jump")

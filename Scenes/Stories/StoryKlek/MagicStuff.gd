extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var klekAnimSide = true

func _on_Klek_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			print("clicked")
			if klekAnimSide == true:
				$Klek/AnimationPlayer.play("New Anim")
				klekAnimSide = false
			else:
				$Klek/AnimationPlayer.play_backwards("New Anim")
				klekAnimSide = true
			


func _on_Area2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$Area2/AnimationPlayer.play("New Anim")


func _on_Area1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$Area1/AnimationPlayer.play("New Anim")

func _on_Area3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$Area3/AnimationPlayer.play("New Anim")

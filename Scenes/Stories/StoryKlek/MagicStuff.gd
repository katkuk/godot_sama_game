extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSound.stopSound("AngryVolos")
	GlobalSound.stopSound("KlekIsSorry")
	GlobalSound.stopSound("Snoring")
	GlobalSound.playSound("Thunder")
	GlobalSound.playSound("Magic")


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
				GlobalSound.playSound("WhisleUp")
				klekAnimSide = false
			else:
				$Klek/AnimationPlayer.play_backwards("New Anim")
				GlobalSound.playSound("WhisleDown")
				klekAnimSide = true
			


func _on_Area2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Chime")
			$Area2/AnimationPlayer.play("New Anim")


func _on_Area1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Chime")
			$Area1/AnimationPlayer.play("New Anim")

func _on_Area3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Chime")
			$Area3/AnimationPlayer.play("New Anim")

extends Node2D
var klekAnimSide = true

var soundsUsed = [
	"Klek/Thunder",
	"Klek/Magic",
	"Klek/Chime",
	"UI/WhisleUp",
	"UI/WhisleDown"
]

func stopSounds():
	for sound in soundsUsed:
		if GlobalSound.get_node(sound).is_playing():
			GlobalSound.get_node(sound).stop()

func _ready():
	GlobalSound.playSound("Klek/Thunder")
	GlobalSound.playSound("Klek/Magic")

func _on_Klek_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if klekAnimSide == true:
				$Klek/AnimationPlayer.play("New Anim")
				GlobalSound.playSound("UI/WhisleUp")
				klekAnimSide = false
			else:
				$Klek/AnimationPlayer.play_backwards("New Anim")
				GlobalSound.playSound("UI/WhisleDown")
				klekAnimSide = true

func _on_Area2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Chime")
			$Area2/AnimationPlayer.play("New Anim")

func _on_Area1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Chime")
			$Area1/AnimationPlayer.play("New Anim")

func _on_Area3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Chime")
			$Area3/AnimationPlayer.play("New Anim")

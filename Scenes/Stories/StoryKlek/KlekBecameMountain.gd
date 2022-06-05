extends Node2D
export(String) var GUIColorHex

var soundsUsed = [
	"BgSounds/KlekSnoring",
	"Klek/Jump"
]

func stopSounds():
	for sound in soundsUsed:
		if GlobalSound.get_node(sound).is_playing():
			GlobalSound.get_node(sound).stop()

func _ready():
	GlobalSound.playSound("BgSounds/KlekSnoring")

func _on_Sheep5_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Jump")
			get_node("Sheep5/AnimationPlayer").play("jump")

func _on_Sheep3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Jump")
			get_node("Sheep3/AnimationPlayer").play("jump")

func _on_Sheep1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Jump")
			get_node("Sheep1/AnimationPlayer").play("jump")

func _on_Sheep2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Jump")
			get_node("Sheep2/AnimationPlayer").play("jump")

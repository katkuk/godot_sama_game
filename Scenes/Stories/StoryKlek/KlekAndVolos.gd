extends Node2D
export(String) var GUIColorHex = "#a0403e"

onready var volosRunningAP = get_node("Volos/VolosRunning/Running")
onready var volosRunning = get_node("Volos/VolosRunning")
onready var volosAngryAP = get_node("Volos/VolosAngry/Angry")
onready var volosAngry = get_node("Volos/VolosAngry")

var soundsUsed = [
	"Klek/StuffFalling",
	"Klek/KlekIsSorry",
	"Klek/AngryVolos"
]

func stopSounds():
	for sound in soundsUsed:
		if GlobalSound.get_node(sound).is_playing():
			GlobalSound.get_node(sound).stop()

func _ready():
	GlobalSound.playSound("Klek/StuffFalling")
	GlobalSound.playSound("Klek/KlekIsSorry")
	yield(get_tree().create_timer(1.5), "timeout")
	volosRunningAP.play("running")
	yield(volosRunningAP, "animation_finished")
	GlobalSound.playSound("Klek/AngryVolos")
	volosRunning.visible = false
	volosAngry.visible = true
	volosAngryAP.play("angry")

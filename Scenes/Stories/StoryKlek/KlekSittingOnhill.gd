extends Node2D
export(String) var GUIColorHex = "#a0403e"
onready var klekDown = true
onready var klekAP = get_node("klekSitting2/klekSitting/AnimationPlayer")
onready var speechBubbleAP = get_node("SpeachBubble/AnimationPlayer")

var soundsUsed = [
	"Klek/RumblingStomach",
	"Klek/Jump",
	"UI/WhisleUp",
	"UI/WhisleDown"
]

func stopSounds():
	for sound in soundsUsed:
		if GlobalSound.get_node(sound).is_playing():
			GlobalSound.get_node(sound).stop()

func _ready():
	GlobalSound.playSound("Klek/RumblingStomach")
	get_node("SpeachBubble/AnimationPlayer").play("speachBubble")
	yield(get_tree().create_timer(1.0), "timeout")

func _on_klekSitting2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if klekDown == true:
				speechBubbleAP.play_backwards("speachBubble")
				yield(speechBubbleAP, "animation_finished")
				klekAP.play("standUp")
				GlobalSound.playSound("UI/WhisleUp")
				klekDown = false
				yield(klekAP, "animation_finished")
				klekAP.play("idleStanding")
			else:
				klekAP.play("sitDown")
				GlobalSound.playSound("UI/WhisleDown")
				yield(klekAP, "animation_finished")
				klekAP.play("idleSitting")
				yield(get_tree().create_timer(0.5), "timeout")
				speechBubbleAP.play("speachBubble")
				klekDown = true

func _on_Sheep5_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Jump")
			get_node("Sheep5/AnimationPlayer").play("jump")

func _on_Sheep4_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Jump")
			get_node("Sheep4/AnimationPlayer").play("jump")

func _on_Sheep2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Jump")
			get_node("Sheep2/AnimationPlayer").play("jump")

func _on_Sheep1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Jump")
			get_node("Sheep1/AnimationPlayer").play("jump")

func _on_Sheep3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Klek/Jump")
			get_node("Sheep3/AnimationPlayer").play("jump")

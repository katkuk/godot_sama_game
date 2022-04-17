extends Node2D
export(String) var GUIColorHex = "#61429d"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSound.playSound("RumblingStomach")
	get_node("SpeachBubble/AnimationPlayer").play("speachBubble")
	yield(get_tree().create_timer(1.0), "timeout")
	
onready var klekDown = true
onready var klekAP = get_node("klekSitting2/klekSitting/AnimationPlayer")
onready var speechBubbleAP = get_node("SpeachBubble/AnimationPlayer")
	
	
func _on_klekSitting2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if klekDown == true:
				speechBubbleAP.play_backwards("speachBubble")
				yield(speechBubbleAP, "animation_finished")
				GlobalSound.playSound("WhisleUp")
				klekAP.play("standUp")
				klekDown = false
				yield(klekAP, "animation_finished")
				klekAP.play("idleStanding")
			else:
				klekAP.play_backwards("standUp")
				GlobalSound.playSound("WhisleDown")
				yield(klekAP, "animation_finished")
				klekAP.play("idleSitting")	
				yield(get_tree().create_timer(0.5), "timeout")
				speechBubbleAP.play("speachBubble")
				klekDown = true


func _on_Sheep5_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Jump")
			get_node("Sheep5/AnimationPlayer").play("jump")


func _on_Sheep4_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Jump")
			get_node("Sheep4/AnimationPlayer").play("jump")


func _on_Sheep2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Jump")
			get_node("Sheep2/AnimationPlayer").play("jump")


func _on_Sheep1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Jump")
			get_node("Sheep1/AnimationPlayer").play("jump")


func _on_Sheep3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Jump")
			get_node("Sheep3/AnimationPlayer").play("jump")

	

extends Node

const Fish1 = preload("res://Scenes/Stories/StoryCaroline/Fish.tscn")
const Fish2 = preload("res://Scenes/Stories/StoryCaroline/Fish2.tscn")
var switch = true
onready var timer = get_node("ShootTimer")
const Boom = preload("res://Scenes/Stories/StoryCaroline/Shoot.tscn")
var positionTicker = 0

func _ready():
	timer.connect("timeout", self, "onTimerTimeout")
	timer.start()
	GlobalSound.playSound("Sea")
	GlobalSound.stopSound("HorseRunning")
	GlobalSound.stopSound("Fire")
	
func onTimerTimeout():
	var positions = $Positions.get_children()
	var boom = Boom.instance()
	get_node("Booms").add_child(boom)
	GlobalSound.playSound("CannonBoom")
	if positionTicker == 0:
		boom.position = positions[0].position
	elif positionTicker == 1:
		boom.position = positions[2].position
	elif positionTicker == 2:
		boom.position = positions[1].position
	positionTicker = positionTicker+1
	if positionTicker == 3:
		positionTicker = 0
	yield(get_tree().create_timer(1.0), "timeout")
	boom.queue_free()
	

func _on_fishClickArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		GlobalSound.playSound("FishJump")
		if event.pressed:
			switch = !switch
			if switch == true:
				var fish = Fish1.instance()
				var main = get_tree().current_scene
				main.add_child(fish)
				fish.position = event.position
				yield(get_tree().create_timer(1.0), "timeout")
				fish.queue_free()
			else:
				var fish = Fish2.instance()
				var main = get_tree().current_scene
				main.add_child(fish)
				fish.position = event.position
				yield(get_tree().create_timer(1.0), "timeout")
				fish.queue_free()

				

		

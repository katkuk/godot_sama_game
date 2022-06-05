extends Node

const Fish1 = preload("res://Scenes/Stories/StoryCaroline/Fish.tscn")
const Fish2 = preload("res://Scenes/Stories/StoryCaroline/Fish2.tscn")
var switch = true
onready var timer = get_node("ShootTimer")
const Boom = preload("res://Scenes/Stories/StoryCaroline/Shoot.tscn")
var positionTicker = 0
var soundsUsed = [
	"Caroline/Sea",
	"Caroline/CannonBoom",
	"Caroline/FishJump"
]

func stopSounds():
	for sound in soundsUsed:
		if GlobalSound.get_node(sound).is_playing():
			GlobalSound.get_node(sound).stop()

func _ready():
	timer.connect("timeout", self, "onTimerTimeout")
	timer.start()
	GlobalSound.playSound("Caroline/Sea")
	
func onTimerTimeout():
	var positions = $Positions.get_children()
	var boom = Boom.instance()
	get_node("Booms").add_child(boom)
	GlobalSound.playSound("Caroline/CannonBoom")
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
		GlobalSound.playSound("Caroline/FishJump")
		if event.pressed:
			switch = !switch
			if switch == true:
				var fish = Fish1.instance()
				add_child(fish)
				fish.position = event.position
				yield(get_tree().create_timer(1.0), "timeout")
				fish.queue_free()
			else:
				var fish = Fish2.instance()
				add_child(fish)
				fish.position = event.position
				yield(get_tree().create_timer(1.0), "timeout")
				fish.queue_free()

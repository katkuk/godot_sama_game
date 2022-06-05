extends Node2D

const Bird = preload("res://Scenes/Stories/StoryCaroline/blackBird.tscn")

onready var timer1 = get_node("Timer1")
onready var counter = 1
var soundsUsed = [
	"Caroline/Fire",
	"Caroline/HorseRunning",
	"Caroline/CannonBoom",
	"Caroline/FunnyScream",
	"Caroline/BirdsFlyAway"
]

func stopSounds():
	for sound in soundsUsed:
		if GlobalSound.get_node(sound).is_playing():
			GlobalSound.get_node(sound).stop()

func _ready():
	timer1.start()
	timer1.connect("timeout", self, "onTimerTimeout")
	GlobalSound.playSound("Caroline/Fire")
	GlobalSound.playSound("Caroline/HorseRunning")

func onTimerTimeout():
	GlobalSound.playSound("Caroline/CannonBoom")
	if counter == 1:
		$boom1/AnimationPlayer.play("explosion")
	elif counter == 2:
		$boom2/AnimationPlayer.play("explosion")
	else:
		$boom3/AnimationPlayer.play("explosion")
	counter = counter + 1
	if counter == 4:
		counter = 1

func _on_barrels_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$ManBehindTheBarrel/AnimationPlayer.play("ManAppears")
			if !GlobalSound.get_node("Caroline/FunnyScream").is_playing():
				GlobalSound.get_node("Caroline/FunnyScream").play()
			$ManBehindTheBarrel/AnimationPlayer.play_backwards("ManAppears")
			print("clicked")

var direction = true

func _on_clickForBlackBirds_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Caroline/BirdsFlyAway")
			var bird = Bird.instance()
			bird.global_position = event.position
			$birdContainer.add_child(bird)
			bird.get_node("CarolineSmallAnim1/AnimationPlayer").play("flyAway")
			if direction == true:
				bird.get_node("CarolineSmallAnim1/AnimationPlayer2").play("direction")
			else:
				bird.get_node("CarolineSmallAnim1/AnimationPlayer3").play("direction")
			direction = !direction
			yield(get_tree().create_timer(1.0), "timeout")
			bird.queue_free()


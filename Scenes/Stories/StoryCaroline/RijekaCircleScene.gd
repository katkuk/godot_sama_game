extends Node2D

onready var explosionTimer = $explosionTimer
onready var shootTimer = $RijekaCircle/boat/shootTimer
onready var counter = 1
onready var counter2 = 1

const Bird = preload("res://Scenes/Stories/StoryCaroline/blackBird.tscn")
onready var direction = true

var soundsUsed = [
	"Caroline/Sea",
	"Caroline/CannonBoom",
	"Caroline/BirdsFlyAway"
]

func stopSounds():
	for sound in soundsUsed:
		if GlobalSound.get_node(sound).is_playing():
			GlobalSound.get_node(sound).stop()

func _ready():
	explosionTimer.start()
	explosionTimer.connect("timeout", self, "playExplosion")
	shootTimer.start()
	shootTimer.connect("timeout", self, "playShoot")
	GlobalSound.playSound("Caroline/Sea")

func playExplosion():
	if counter == 1:
		$RijekaCircle/boom/AnimationPlayer.play("boom")
	elif counter == 2:
		$RijekaCircle/boom2/AnimationPlayer.play("boom")
	elif counter == 3:
		$RijekaCircle/boom3/AnimationPlayer.play("boom")
	elif counter == 4:
		counter = 1
		explosionTimer.stop()
	counter = counter + 1
	
func playShoot():
	if counter2 == 1:
		GlobalSound.playSound("Caroline/CannonBoom")
		$RijekaCircle/boat/CarolineSmallAnim2/AnimationPlayer.play("shoot")
	elif counter2 == 2:
		GlobalSound.playSound("Caroline/CannonBoom")
		$RijekaCircle/boat/CarolineSmallAnim3/AnimationPlayer.play("shoot")
	elif counter2 == 3:
		GlobalSound.playSound("Caroline/CannonBoom")
		$RijekaCircle/boat/CarolineSmallAnim4/AnimationPlayer.play("shoot")
	elif counter2 == 4:
		counter2 = 1
		shootTimer.stop()
	counter2 = counter2 + 1


func _on_birdClickArea_input_event(viewport, event, shape_idx):
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

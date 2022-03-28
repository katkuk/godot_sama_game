extends Node2D

const Bird = preload("res://Scenes/Stories/StoryCaroline/blackBird.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_barrels_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$ManBehindTheBarrel/AnimationPlayer.play("ManAppears")
			$ManBehindTheBarrel/AnimationPlayer.play_backwards("ManAppears")
			print("clicked")


var direction = true

func _on_clickForBlackBirds_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			var bird = Bird.instance()
			bird.global_position = event.position
			$birdContainer.add_child(bird)
			bird.get_node("CarolineSmallAnim1/AnimationPlayer").play("flyAway")
			if direction == true:
				bird.get_node("CarolineSmallAnim1/AnimationPlayer2").play("direction")
			else:
				bird.get_node("CarolineSmallAnim1/AnimationPlayer3").play("direction")
			direction = !direction

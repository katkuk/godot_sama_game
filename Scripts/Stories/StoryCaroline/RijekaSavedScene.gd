extends Node2D

const Flower = preload("res://Scenes/Stories/StoryCaroline/Flower.tscn")
onready var flowerContainer = $FlowerContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSound.playSound("UI/HappyKids")
	GlobalSound.playSound("UI/WinNotes")
	GlobalSound.stopSound("Sea")

var counter = 0
var left = true

func _on_FlowerClickArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
			if event.pressed:
				GlobalSound.playSound("throwFlower")
				var flower = Flower.instance()
				flower.get_node("flower").frame = counter
				if left == true:
					flower.get_node("flower/1").play("animateFlowerLeft")
				else:
					flower.get_node("flower/2").play("animateFlowerLeft")
				left = !left
				counter = counter + 1
				if counter == 4:
					counter = 0
				flowerContainer.add_child(flower)
				flower.global_position = event.position
		

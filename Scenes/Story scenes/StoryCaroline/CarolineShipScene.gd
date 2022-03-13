extends Node

const Fish = preload("res://Scenes/Story scenes/StoryCaroline/Fish.tscn")
const Wave = preload("res://Scenes/Story scenes/StoryCaroline/Wave1.tscn")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var fish = Fish.instance()
			#add scene as a child of another node
			var main = get_tree().current_scene
			main.add_child(fish)
			fish.global_position = event.position




extends Node

const Fish = preload("res://Scenes/Story scenes/StoryCaroline/Fish.tscn")
const Wave = preload("res://Scenes/Story scenes/StoryCaroline/Wave1.tscn")

func _unhandled_input(event):
	if !event.is_action_pressed("Click"):
		return
	if event.button_index == BUTTON_LEFT and event.pressed:
		print("click")
		var fish = Fish.instance()
		#add scene as a child of another node
		var main = get_tree().current_scene
		main.add_child(fish)
		fish.global_position = event.position

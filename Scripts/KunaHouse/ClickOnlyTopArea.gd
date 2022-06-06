extends Area2D
#:= means its also typed when you declare it
export var group := "clickable"

#READ BEFORE JUDGING OKE :D
#below is absolut insanity - since hanginglights are on paralax I had to force
#the code to check the original parent index - paralaxbackground index instead of
#the index of hanging lights since that will always be 0

func _ready():
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	add_to_group(group)

func mouse_entered():
	if self.name == "HangingLights":
		get_parent().get_parent().add_to_group(group + "hovered")
	else:
		add_to_group(group + "hovered")

func mouse_exited():
	if self.name == "HangingLights":
		get_parent().get_parent().remove_from_group(group + "hovered")
	else:
		remove_from_group(group + "hovered")

func is_on_top() -> bool:
	for clickable in get_tree().get_nodes_in_group(group + "hovered"):
		if self.name == "HangingLights":
			if clickable.get_index() > get_parent().get_parent().get_index():
				return false
		else:
			if clickable.get_index() > get_index():
				return false
	return true

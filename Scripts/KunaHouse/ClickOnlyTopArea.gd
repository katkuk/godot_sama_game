extends Area2D
#:= means its also typed when you declare it
export var group := "clickable"

func _ready():
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	add_to_group(group)

func mouse_entered():
	add_to_group(group + "hovered")

func mouse_exited():
	remove_from_group(group + "hovered")

func is_on_top() -> bool:
	for clickable in get_tree().get_nodes_in_group(group + "hovered"):
		if clickable.get_index() > get_index():
			return false
	return true

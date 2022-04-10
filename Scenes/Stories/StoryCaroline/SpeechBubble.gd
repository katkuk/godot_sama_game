extends Area2D

export var group := "clickable"
signal bubbleClicked

func _ready():
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	add_to_group(group)


func _on_SpeechBubble_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and is_on_top():
		emit_signal("bubbleClicked")
		queue_free()

func mouse_entered():
	add_to_group(group + "hovered")

func mouse_exited():
	remove_from_group(group + "hovered")

func is_on_top() -> bool:
	for clickable in get_tree().get_nodes_in_group(group + "hovered"):
		if clickable.get_index() > get_index():
			return false
	return true

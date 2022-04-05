extends Area2D

signal bubbleClicked



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_SpeechBubble_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("bubbleClicked")
			queue_free()


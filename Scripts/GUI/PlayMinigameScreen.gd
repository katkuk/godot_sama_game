extends CanvasLayer

func _ready():
	pass

func _unhandled_input(event):
	if !event.is_action_pressed("Click"):
		return
	print(event)

func _on_Button_pressed():
	GlobalSound.get_node("UI/ButtonClick").play()
	print("Btn pressed")
	Global.loadScene("map")

func _on_XButton_pressed():
	GlobalSound.get_node("UI/ButtonClick").play()
	queue_free()

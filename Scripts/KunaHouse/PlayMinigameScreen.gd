extends CanvasLayer


func _ready():
	pass

func _unhandled_input(event):
	if !event.is_action_pressed("Click"):
		return
	print(event)


func _on_Button_pressed():
	print("Btn pressed")
	


func _on_XButton_pressed():
	queue_free()

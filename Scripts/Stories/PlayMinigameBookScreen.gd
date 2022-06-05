extends Node2D
export(String) var GUIColorHex = "#61429d"

func _ready():
	pass

func _on_PlayBtn_pressed():
	GlobalSound.get_node("UI/ButtonClick").play()
	Global.loadScene(Global.current_story)

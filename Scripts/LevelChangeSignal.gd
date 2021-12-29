extends Node

signal scene_changed(scene_name, btn_name)

export (String) var scene_name = "scene" 

func _on_NewStoryButton_pressed(btn_name: String) -> void:
	emit_signal("scene_changed", scene_name, btn_name)
	print("emiting signal " + scene_name)
	#print(btn_name)
	

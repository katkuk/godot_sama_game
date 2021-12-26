extends Node

signal level_changed(level_name)

export (String) var level_name = "level" 

func _on_NextSceneButton_pressed():
	emit_signal("level_changed", level_name)
	

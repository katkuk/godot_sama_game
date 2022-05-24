extends Control
onready var progressBar = get_node("ColorRect/CenterContainer/VBoxContainer/LoadingBar")

func _ready():
	pass

func _on_Timer_timeout():
	progressBar.value+=1

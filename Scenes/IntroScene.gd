extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_settings_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$SettingsPopup/SettingsAP.play("appear")
			
func _on_closeSettings_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$SettingsPopup/SettingsAP.play_backwards("appear")
			$IntroScreen.visible = true

func _on_intro_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$InfoPopup/InfoAP.play("appear")

func _on_closeInfo_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$InfoPopup/InfoAP.play_backwards("appear")

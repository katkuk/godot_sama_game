extends Node2D

onready var settingsBtn = get_node("IntroScreenGUI/Settings")

func _ready():
	pass # Replace with function body.

func _on_Play_pressed():
	Global.loadScene("main")

func _on_Settings_pressed():
	$SettingsPanel/SettingsPopup/SettingsAP.play("appear")

func _on_Info_pressed():
	$InfoPanel/InfoPopup/InfoAP.play("appear")

func _on_CloseInfoBtn_pressed():
	$InfoPanel/InfoPopup/InfoAP.play_backwards("appear")

func _on_CloseSettingsBtn_pressed():
	$SettingsPanel/SettingsPopup/SettingsAP.play_backwards("appear")

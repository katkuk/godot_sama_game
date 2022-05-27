extends Node2D

onready var settingsBtn = get_node("IntroScreenGUI/Settings")

func _ready():
	GlobalSound.get_node("BgSounds/BGMusicGramophone").play()

func _on_Play_pressed():
	Global.loadScene("main")

func _on_Settings_pressed():
	if GlobalSound.get_node("UI/WhisleDown").is_playing():
		GlobalSound.get_node("UI/WhisleDown").stop()
	if !GlobalSound.get_node("UI/WhisleUp").is_playing():
		GlobalSound.get_node("UI/WhisleUp").play()
	$SettingsPanel/SettingsPopup/SettingsAP.play("appear")

func _on_Info_pressed():
	if GlobalSound.get_node("UI/WhisleDown").is_playing():
		GlobalSound.get_node("UI/WhisleDown").stop()
	if !GlobalSound.get_node("UI/WhisleUp").is_playing():
		GlobalSound.get_node("UI/WhisleUp").play()
	$InfoPanel/InfoPopup/InfoAP.play("appear")

func _on_CloseInfoBtn_pressed():
	if GlobalSound.get_node("UI/WhisleUp").is_playing():
		GlobalSound.get_node("UI/WhisleUp").stop()
	if !GlobalSound.get_node("UI/WhisleDown").is_playing():
		GlobalSound.get_node("UI/WhisleDown").play()
	$InfoPanel/InfoPopup/InfoAP.play_backwards("appear")

func _on_CloseSettingsBtn_pressed():
	if GlobalSound.get_node("UI/WhisleUp").is_playing():
		GlobalSound.get_node("UI/WhisleUp").stop()
	if !GlobalSound.get_node("UI/WhisleDown").is_playing():
		GlobalSound.get_node("UI/WhisleDown").play()
	$SettingsPanel/SettingsPopup/SettingsAP.play_backwards("appear")

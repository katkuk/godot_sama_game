extends Control
class_name MinigameOnScreenGUI

onready var confirmPopUp = get_node("ConfirmPopUp")
onready var textLabel = get_node("ConfirmPopUp/Text")
onready var yesTextLabel = get_node("ConfirmPopUp/YesBtn/YesText")
onready var noTextLabel = get_node("ConfirmPopUp/NoBtn/NoText")

var text
var yesText
var noText

signal restartMinigame

func _ready():
	confirmPopUp.visible = false
	updateText()

func init(var t, var yt, var nt):
	text = t
	yesText = yt
	noText = nt

func updateText():
	textLabel.set_text(text)
	yesTextLabel.set_text(yesText)
	noTextLabel.set_text(noText)

func _on_HomeBtn_pressed():
	confirmPopUp.visible = true

func _on_ResetBtn_pressed():
	emit_signal("restartMinigame")

func _on_YesBtn_pressed():
	GlobalSound.stopAllBackgroundSounds()
	queue_free()
	Global.loadScene("kuna")

func _on_NoBtn_pressed():
	confirmPopUp.visible = false

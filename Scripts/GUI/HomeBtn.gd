extends Control
class_name HomeBtn

onready var confirmPopUp = get_node("ConfirmPopUp")
onready var textLabel = get_node("ConfirmPopUp/Text")
onready var yesTextLabel = get_node("ConfirmPopUp/YesBtn/YesText")
onready var noTextLabel = get_node("ConfirmPopUp/NoBtn/NoText")
onready var homeBtn = get_node("HomeBtn")

var text
var yesText
var noText
var color

func _ready():
	confirmPopUp.visible = false
	updateText()
	updateColor()

func init(var t, var yt, var nt, var c):
	text = t
	yesText = yt
	noText = nt
	color = c

func updateText():
	textLabel.set_text(text)
	yesTextLabel.set_text(yesText)
	noTextLabel.set_text(noText)

func updateColor():
	homeBtn.set_modulate(Color(color))

func _on_HomeBtn_pressed():
	confirmPopUp.visible = true

func _on_YesBtn_pressed():
	queue_free()
	Global.loadScene("kuna")

func _on_NoBtn_pressed():
	confirmPopUp.visible = false


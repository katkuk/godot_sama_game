extends Control
class_name HomeBtn

onready var confirmPopUp = get_node("ConfirmPopUp")
onready var textLabel = get_node("ConfirmPopUp/Text")
onready var yesTextLabel = get_node("ConfirmPopUp/YesBtn/YesText")
onready var noTextLabel = get_node("ConfirmPopUp/NoBtn/NoText")
onready var homeBtn = get_node("HomeBtn")

var text : String
var yesText : String
var noText : String
var color : String
var wantsPopup : bool

func _ready():
	confirmPopUp.visible = false
	updateText()
	updateColor()

func init(var t, var yt, var nt, var c, var w):
	text = t
	yesText = yt
	noText = nt
	color = c
	wantsPopup = w

func updateText():
	textLabel.set_text(text)
	yesTextLabel.set_text(yesText)
	noTextLabel.set_text(noText)

func updateColor():
	homeBtn.set_modulate(Color(color))

func _on_HomeBtn_pressed():
	GlobalSound.get_node("UI/ButtonClick").play()
	if wantsPopup:
		confirmPopUp.visible = true
	else:
		queue_free()
		Global.loadScene("kuna")

func _on_YesBtn_pressed():
	GlobalSound.get_node("UI/ButtonClick").play()
	queue_free()
	Global.loadScene("kuna")

func _on_NoBtn_pressed():
	GlobalSound.get_node("UI/ButtonClick").play()
	confirmPopUp.visible = false


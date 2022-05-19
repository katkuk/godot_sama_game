extends Control
class_name MinigameIntroPopUp
var minigamePic
var text
signal startMinigame

onready var textLabel = get_node("Text")
onready var pictures = get_node("Pictures").get_children()

func _ready():
	for picture in pictures:
		picture.visible = false
	
	updateText()
	updatePicture()

func init(var t, var m):
	text = t
	minigamePic = m

func updateText():
	textLabel.set_text(text)

func updatePicture():
	for picture in pictures:
		if picture.name.to_lower() == minigamePic.to_lower():
			picture.visible = true
			if picture.has_node("Animation"):
				picture.get_node("Animation").get_animation("anim").set_loop(true)
				picture.get_node("Animation").play("anim")

func _on_PlayMinigameBtn_pressed():
	queue_free()
	emit_signal("startMinigame")

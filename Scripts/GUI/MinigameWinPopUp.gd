extends Control
class_name MinigameWinPopUp
var text
var minigamePic
signal restartMinigame

onready var textLabel = get_node("Background/Text")
onready var pictures = get_node("Pictures").get_children()

func _ready():
	if !GlobalSound.get_node("UI/WinNotes").is_playing():
		GlobalSound.get_node("UI/WinNotes").play()
	if !GlobalSound.get_node("UI/HappyKids").is_playing():
		GlobalSound.get_node("UI/HappyKids").play()
	
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

func _on_HomeBtn_pressed():
	stopUISounds()
	GlobalSound.stopAllBackgroundSounds()
	queue_free()
	Global.loadScene("kuna")

func _on_RestartBtn_pressed():
	stopUISounds()
	queue_free()
	emit_signal("restartMinigame")

func stopUISounds():
	if GlobalSound.get_node("UI/WinNotes").is_playing():
		GlobalSound.get_node("UI/WinNotes").stop()
	if GlobalSound.get_node("UI/HappyKids").stop():
		GlobalSound.get_node("UI/HappyKids").play()

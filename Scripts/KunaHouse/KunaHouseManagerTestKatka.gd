extends Node2D

onready var kuna = get_parent().get_node("House/Kuna")
#GET INTERACTION OBJECTS
onready var interactionObjects = get_parent().get_node("House/InteractionObjects")
onready var carolinePicture = interactionObjects.get_node("CarolinePicture")
onready var klekCards = interactionObjects.get_node("KlekCards")
onready var plitvicePicture = interactionObjects.get_node("PlitvicePicture")
onready var map = interactionObjects.get_node("Map")
#GET CLICKABLE OBJECTS
onready var clickableObjects = get_parent().get_node("House/ClickableObjects")
onready var gramophone = clickableObjects.get_node("Gramophone")
onready var bigWindow = clickableObjects.get_node("BigWindow")
onready var smallPlant = clickableObjects.get_node("SmallPlant")
onready var bigLampAleks = clickableObjects.get_node("BigLampAleks")
onready var hangingLights = clickableObjects.get_node("HangingLights")
onready var yellowFlower = clickableObjects.get_node("YellowFlower")
onready var bigPlant = clickableObjects.get_node("BigPlant")
onready var smallBedSideLamp = clickableObjects.get_node("SmallBedSideLamp")

#down is for the big window roller
var down = true;
var gramophoneIsPlaying = false
var playMinigameBtn = preload("res://Scenes/GUI/PlayMinigameBtn.tscn")

func _ready():
	pass

#--------- CLICKABLE OBJECTS START - objects that do stuff when clicked
func _on_Gramophone_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and gramophone.is_on_top():
		var sprite = gramophone.get_node("Sprite")
		var animation = gramophone.get_node("Sprite/Animation")
		if animation.is_playing():
			gramophoneIsPlaying = false
			animation.stop()
			sprite.frame = 3
		else:
			gramophoneIsPlaying = true
			animation.play("playingMusic")

func _on_BigWindow_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and bigWindow.is_on_top():
		if down == true:
			bigWindow.frame = bigWindow.frame - 1
			if bigWindow.frame == 0:
				down = false
		elif down == false:
			bigWindow.frame = bigWindow.frame + 1
			if bigWindow.frame == 3:
				down = true

func _on_SmallPlant_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and smallPlant.is_on_top():
		var sprite = smallPlant.get_node("Sprite")
		var animation = smallPlant.get_node("Sprite/Animation")
		if animation.is_playing():
			animation.stop()
			sprite.frame = 0
		else:
			animation.play("plant")

func _on_BigLampAleks_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and bigLampAleks.is_on_top():
		var sprite = bigLampAleks.get_node("Sprite")
		sprite.frame = !sprite.frame

func _on_HangingLights_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and hangingLights.is_on_top():
		hangingLights.get_node("LightBubbles").visible = !hangingLights.get_node("LightBubbles").visible

func _on_YellowFlower_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and yellowFlower.is_on_top():
		var sprite = yellowFlower.get_node("Sprite")
		var animation = yellowFlower.get_node("Sprite/Animation")
		if animation.is_playing():
			animation.stop()
			sprite.frame = 0
		else:
			animation.play("plantMove")

func _on_BigPlant_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and bigPlant.is_on_top():
		var sprite = bigPlant.get_node("Sprite")
		var animation = bigPlant.get_node("Sprite/Animation")
		if animation.is_playing():
			animation.stop()
			sprite.frame = 0
		else:
			animation.play("plantMove")

func _on_SmallBedSideLamp_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and smallBedSideLamp.is_on_top():
		var sprite = smallBedSideLamp.get_node("Sprite")
		sprite.frame = !sprite.frame
#--------- CLICKABLE OBJECTS END

#--------- INTERACTABLE OBJECTS - objects that lead to a minigame
func _on_InteractionObjects_input_event(viewport, event, shape_idx):
	if !event.is_action_pressed("Click"):
		return
	var position = interactionObjects.get_child(shape_idx).get_node("position")
	if position.get_child_count() == 0:
		var playBtn = playMinigameBtn.instance()
		playBtn.init(position.linkToScene)
		position.add_child(playBtn)
	else:
		position.get_child(0).queue_free()

func _on_CarolinePicture_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and carolinePicture.is_on_top():
		displayPlayBtnForObject(carolinePicture)

func _on_KlekCards_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and klekCards.is_on_top():
		displayPlayBtnForObject(klekCards)

func _on_PlitvicePicture_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and plitvicePicture.is_on_top():
		displayPlayBtnForObject(plitvicePicture)

func _on_Map_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and map.is_on_top():
		displayPlayBtnForObject(map)

func displayPlayBtnForObject(object):
	var position = object.get_node("Position")
	if position.get_child_count() == 0:
		var playBtn = playMinigameBtn.instance()
		playBtn.init(position.linkToScene)
		position.add_child(playBtn)
	else:
		position.get_child(0).queue_free()

#var kunaSceneState = {
#	"kunaPos" : 1554,
#	"kunaInteractingWith" : null,
#	"gramophone" : false,
#	"hangingLights" : true,
#	"bigLampAleks" : false,
#	"smallSideLamp" : false

func _unhandled_input(event):
	if Input.is_key_pressed(KEY_SPACE):
		saveScene()
	else:
		return

func saveScene():
	Global.kunaSceneState.kunaPos = kuna.position.x
	Global.kunaSceneState.kunaInteractingWith = kuna.interactingWithObject
	Global.kunaSceneState.gramophone = gramophoneIsPlaying
	Global.kunaSceneState.hangingLights = (true if hangingLights.get_node("LightBubbles").visible else false)
	Global.kunaSceneState.bigLampAleks = (true if (bigLampAleks.get_node("Sprite").frame == 1) else false)
	Global.kunaSceneState.smallBedSideLamp = (true if (smallBedSideLamp.get_node("Sprite").frame == 1) else false)
	print(Global.kunaSceneState)

func loadScene():
	pass

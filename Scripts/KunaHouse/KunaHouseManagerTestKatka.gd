extends Node2D

onready var kuna = get_parent().get_node("House/Kuna")
#GET INTERACTION OBJECTS
onready var interactionObjects = get_parent().get_node("House/InteractionObjects")
onready var kunaObjects = get_parent().get_node("House/KunaObjects")
onready var carolinePicture = interactionObjects.get_node("CarolinePicture")
onready var klekCards = interactionObjects.get_node("KlekCards")
onready var plitvicePicture = interactionObjects.get_node("PlitvicePicture")
onready var map = interactionObjects.get_node("Map")
onready var chair = kunaObjects.get_node("chair")
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
onready var camera = get_parent().get_node("Camera")

onready var BGM = GlobalSound.get_node("BgSounds/BGMusic")
onready var BGMGramophone = GlobalSound.get_node("BgSounds/BGMusicGramophone")


func _ready():
	loadScene()
	playBackgroundMusic()

func playBackgroundMusic():
	if gramophoneIsPlaying == false:
		BGM.playing = true
		BGMGramophone.playing = false
	elif gramophoneIsPlaying == true:
		BGM.playing = false
		BGMGramophone.playing = true
		
#--------- CLICKABLE OBJECTS START - objects that do stuff when clicked
func _on_Gramophone_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and gramophone.is_on_top():
		var sprite = gramophone.get_node("Sprite")
		var animation = gramophone.get_node("Sprite/Animation")
		if animation.is_playing():
			gramophoneIsPlaying = false
			animation.stop()
			sprite.frame = 3
			playBackgroundMusic()
		else:
			gramophoneIsPlaying = true
			animation.play("playingMusic")
			playBackgroundMusic()

func _on_BigWindow_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and bigWindow.is_on_top():
		var bigWindowSprite = bigWindow.get_node("Sprite")
		GlobalSound.playSound("CurtainOne")
		print('curtain')
		if down == true:
			bigWindowSprite.frame = bigWindowSprite.frame - 1
			if bigWindowSprite.frame == 0:
				down = false
		elif down == false:
			bigWindowSprite.frame = bigWindowSprite.frame + 1
			if bigWindowSprite.frame == 3:
				down = true

func _on_SmallPlant_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and smallPlant.is_on_top():
		var sprite = smallPlant.get_node("Sprite")
		var animation = smallPlant.get_node("Sprite/Animation")
		GlobalSound.playSound("MovePlantTwo")
		if animation.is_playing():
			animation.stop()
			sprite.frame = 0
		else:
			animation.play("plant")

func _on_BigLampAleks_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and bigLampAleks.is_on_top():
		var sprite = bigLampAleks.get_node("Sprite")
		sprite.frame = !sprite.frame
		GlobalSound.playSound("LightSwitch")

func _on_HangingLights_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and hangingLights.is_on_top():
		hangingLights.get_node("LightBubbles").visible = !hangingLights.get_node("LightBubbles").visible
		GlobalSound.playSound("LightSwitch")

func _on_YellowFlower_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and yellowFlower.is_on_top():
		var sprite = yellowFlower.get_node("Sprite")
		var animation = yellowFlower.get_node("Sprite/Animation")
		GlobalSound.playSound("Poing")
		if animation.is_playing():
			animation.stop()
			sprite.frame = 0
		else:
			animation.play("plantMove")

func _on_BigPlant_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and bigPlant.is_on_top():
		var sprite = bigPlant.get_node("Sprite")
		var animation = bigPlant.get_node("Sprite/Animation")
		GlobalSound.playSound("MovePlantOne")
		if animation.is_playing():
			animation.stop()
			sprite.frame = 0
		else:
			animation.play("plantMove")

func _on_SmallBedSideLamp_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and smallBedSideLamp.is_on_top():
		var sprite = smallBedSideLamp.get_node("Sprite")
		sprite.frame = !sprite.frame
		GlobalSound.playSound("LightSwitch")
#--------- CLICKABLE OBJECTS END

#--------- INTERACTABLE OBJECTS - objects that lead to a minigame
func _on_CarolinePicture_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and carolinePicture.is_on_top():
		displayPlayBtnForObject(carolinePicture)
		GlobalSound.playSound("Pop")

func _on_KlekCards_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and klekCards.is_on_top():
		displayPlayBtnForObject(klekCards)
		GlobalSound.playSound("Pop")

func _on_PlitvicePicture_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and plitvicePicture.is_on_top():
		displayPlayBtnForObject(plitvicePicture)
		GlobalSound.playSound("Pop")

func _on_Map_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and map.is_on_top():
		displayPlayBtnForObject(map)
		GlobalSound.playSound("Pop")

func displayPlayBtnForObject(object):
	var position = object.get_node("Position")
	if position.get_child_count() == 0:
		var playBtn = playMinigameBtn.instance()
		playBtn.init(position.linkToScene)
		position.add_child(playBtn)
	else:
		position.get_child(0).queue_free()

func saveScene():
	Global.kunaSceneState.kunaPos = kuna.position.x
	Global.kunaSceneState.cameraPos = camera.position.x
	Global.kunaSceneState.kunaInteractingWith = (kuna.interactingWithObject.name if kuna.interactingWithObject != null else "")
	Global.kunaSceneState.kunaState = kuna.state
	Global.kunaSceneState.gramophone = gramophoneIsPlaying
	Global.kunaSceneState.hangingLights = (true if hangingLights.get_node("LightBubbles").visible else false)
	Global.kunaSceneState.bigLampAleks = (true if (bigLampAleks.get_node("Sprite").frame == 1) else false)
	Global.kunaSceneState.smallBedSideLamp = (true if (smallBedSideLamp.get_node("Sprite").frame == 1) else false)
	print(Global.kunaSceneState)

func loadScene():
	camera.position.x = Global.kunaSceneState.cameraPos
	#kuna deals with the state on its own
	if Global.kunaSceneState.kunaInteractingWith != "":
		var intObjectPath = Global.kunaSceneState.kunaInteractingWith
		var intObject = get_parent().get_node("House/KunaObjects/"+intObjectPath)
		intObject.setStateInteracting()
	else:
		kuna.position.x = Global.kunaSceneState.kunaPos
	#clickable objects
	if Global.kunaSceneState.gramophone:
		gramophone.get_node("Sprite/Animation").play("playingMusic")
		gramophoneIsPlaying = true
	elif !Global.kunaSceneState.gramophone:
		gramophoneIsPlaying = false
		gramophone.get_node("Sprite/Animation").stop()
		gramophone.get_node("Sprite").frame = 3
	hangingLights.get_node("LightBubbles").visible = Global.kunaSceneState.hangingLights
	bigLampAleks.get_node("Sprite").frame = 1 if Global.kunaSceneState.bigLampAleks else 0
	smallBedSideLamp.get_node("Sprite").frame = 1 if Global.kunaSceneState.smallBedSideLamp else 0


func _on_chair_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click") and chair.is_on_top() and not chair.interacting :
		chair.get_node("animation").play("empty")
		chair.get_node("RockingChairSound").play()

func _on_chairAnimation_animation_finished(anim_name):
	chair.get_node("animation").play("sitting")

extends Node2D

onready var houseTween = get_parent().get_node("House/MoveHouseTween")
onready var house = get_parent().get_node("House")
onready var currentHousePosition = house.position;
onready var arrowRight = get_parent().get_node("HouseGUI/HouseArrowRight")
onready var arrowLeft = get_parent().get_node("HouseGUI/HouseArrowLeft")
onready var kunaSelected = false;
onready var kuna = get_parent().get_node("House/kuna")
onready var interactionObjects = get_parent().get_node("House/InteractionObjects")
onready var down = true;

onready var bigWindow = get_parent().get_node("House/bigWindow2/bigWindow")
onready var houseOffset = 0
var playMinigameBtn = preload("res://Scenes/GUI/PlayMinigameBtn.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	if kunaSelected:
		followMouse()
		
func followMouse():
	kuna.position = get_global_mouse_position() + Vector2(houseOffset, 0)
			

func _on_kuna_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			kunaSelected = true
			kuna.get_node("kunaIdle").visible = false
			kuna.get_node("kunaWalking").visible = true
			kuna.get_node("kunaWalking/kunaWalkingAP").play("walking")
		else:
			kuna.get_node("kunaIdle").visible = true;
			kuna.get_node("kunaWalking").visible = false;
			kunaSelected = false
	

func _on_HouseArrowRight_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			var nextHousePosition = currentHousePosition - Vector2(1000,0);
			if nextHousePosition.x == -7000:
				nextHousePosition = Vector2(-6000,0);
			else:
				houseOffset = houseOffset + 1000
			houseTween.interpolate_property(house, "position", currentHousePosition, nextHousePosition,1,Tween.TRANS_SINE, Tween.EASE_OUT)
			houseTween.start()
			currentHousePosition = nextHousePosition


func _on_HouseArrowLeft_input_event(viewport, event, shape_idx):
		if event is InputEventMouseButton:
			if event.pressed:
				var nextHousePosition = currentHousePosition + Vector2(1000,0);
				if nextHousePosition.x == 1000:
					nextHousePosition = Vector2(0,0);
				else:
					houseOffset = houseOffset - 1000
				houseTween.interpolate_property(house, "position", currentHousePosition, nextHousePosition,1,Tween.TRANS_SINE, Tween.EASE_OUT)
				houseTween.start()
				currentHousePosition = nextHousePosition


func _on_lampAleks2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
			if event.pressed:
				var lamp = get_parent().get_node("House/lampAleks2/lampAleks")
				lamp.frame = !lamp.frame

func _on_gramophone2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			var gramophone = get_parent().get_node("House/gramophone2/gramophone")
			var gramophoneAP = get_parent().get_node("House/gramophone2/gramophone/gramophoneAP")
			if gramophoneAP.is_playing():
				gramophoneAP.stop()
				gramophone.frame = 3
			else:
				gramophoneAP.play("playingMusic")

func _on_smallPlant_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			var smallPlant = get_parent().get_node("House/smallPlant/plantSmall")
			var smallPlantAP = get_parent().get_node("House/smallPlant/AnimationPlayer")
			if smallPlantAP.is_playing():
				smallPlantAP.stop()
				smallPlant.frame = 0
			else:
				smallPlantAP.play("plant")

func _on_flower2_input_event(viewport, event, shape_idx):
		if event is InputEventMouseButton:
			if event.pressed:
				var flower = get_parent().get_node("House/flower2/flower")
				var flowerAP = get_parent().get_node("House/flower2/AnimationPlayer")
				if flowerAP.is_playing():
					flowerAP.stop()
					flower.frame = 0
				else:
					flowerAP.play("plantMove")

func _on_bigWindow_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if down == true:
				bigWindow.frame = bigWindow.frame - 1
				if bigWindow.frame == 0:
					down = false
			elif down == false:
				bigWindow.frame = bigWindow.frame + 1
				if bigWindow.frame == 3:
					down = true

func _on_plantBigA_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			var plantBig = get_parent().get_node("House/plantBigA/plantBig")
			var plantBigAP = get_parent().get_node("House/plantBigA/plantBig/AnimationPlayer")
			if plantBigAP.is_playing():
				plantBigAP.stop()
				plantBig.frame = 0
			else:
				plantBigAP.play("plantMove")

func _on_lampBedsideA_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
			if event.pressed:
				var lamp = get_parent().get_node("House/lampBedsideA/lampBedside")
				lamp.frame = !lamp.frame

func _on_LittleLampsTop_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			var lampsArray = get_parent().get_node("House/LittleLampsTop/lightBubbles").get_children()
			for lamp in lampsArray:
				lamp.visible = !lamp.visible

#interactable objects are objects that lead to a minigame
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

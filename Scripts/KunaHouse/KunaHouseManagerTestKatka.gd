extends Node2D

onready var houseTween = get_parent().get_node("House/MoveHouseTween")
onready var house = get_parent().get_node("House")
onready var currentHousePosition = house.position;
onready var arrowRight = get_parent().get_node("HouseGUI/HouseArrowRight")
onready var arrowLeft = get_parent().get_node("HouseGUI/HouseArrowLeft")


onready var bigWindow = get_parent().get_node("House/bigWindow2/bigWindow")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_HouseArrowRight_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			var nextHousePosition = currentHousePosition - Vector2(1000,0);
			if nextHousePosition.x == -7000:
				nextHousePosition = Vector2(-6000,0);
			houseTween.interpolate_property(house, "position", currentHousePosition, nextHousePosition,1,Tween.TRANS_SINE, Tween.EASE_OUT)
			houseTween.start()
			currentHousePosition = nextHousePosition


func _on_HouseArrowLeft_input_event(viewport, event, shape_idx):
		if event is InputEventMouseButton:
			if event.pressed:
				var nextHousePosition = currentHousePosition + Vector2(1000,0);
				if nextHousePosition.x == 1000:
					nextHousePosition = Vector2(0,0);
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

onready var down = true;

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
			


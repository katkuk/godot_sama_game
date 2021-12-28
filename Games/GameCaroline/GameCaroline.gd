extends Node2D

var pressed = false
var active_line
#onready var color = $ColorRect/Color
var spongeSelected = false
onready var sponge = $ColorRect/Sponge
onready var canvas = $Area2D
onready var animationPlayerSponge = $ColorRect/Sponge/AnimationPlayer
onready var particles = $ColorRect/Sponge/Particles2D


const Colore = preload("res://Games/GameCaroline/Color.tscn")
onready var colorSpawnPoints = $ColorRect/ColorSpawnPoints
onready var colorSetOne = ["#1E1717", "#8B58A5", "#D8BBAE", "#AA645D", "#6D2541", "#D0C1D8"]
onready var currentColor = Color(colorSetOne[0])

func generateColors() :
	var spawnpoints = colorSpawnPoints.get_children()
	var i = -1
	for color in colorSetOne:
			i = i+1
			var currentColor = Colore.instance()
			#print(currentColor.get_child(0).self_modulate)
			currentColor.get_child(0).self_modulate = color
			var main = get_tree().current_scene
			main.add_child(currentColor)
			currentColor.global_position = spawnpoints[i].global_position
			currentColor.connect("colorChanged", self, "onColorChanged")
			
func _ready():
	generateColors()
	
func _process(delta):
	if spongeSelected:
		followMouse()
		if spongeSelected:
			currentColor = "#dfdece"
	
func onColorChanged(message):
	#print('game also knows that color has been clicked')
	#print(message)
	currentColor = message
	
	
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			#print("clicked")
			pressed = true
			active_line = Line2D.new()
			active_line.default_color = currentColor
			active_line.set_texture(load("res://Assets/Textures/GameCaroline/export_ready-12.png"))
			active_line.set_texture_mode(2)
			active_line.width = 50
			add_child(active_line)
		else:
			pressed = false
			
	if event is InputEventMouseMotion:
		if pressed:
			active_line.add_point(event.position)
			#add_child(active_line)
			

func _on_Sponge_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			spongeSelected = true
			animationPlayerSponge.play("rotate")
			particles.emitting = true
		else:
			spongeSelected = false
			animationPlayerSponge.play("rotateBack")
			particles.emitting = false
			
				
func followMouse():
	sponge.position = get_global_mouse_position()
			
			
			
			
			
			

extends Node2D

var pressed = false
var active_line
var currentColor = Color("#8b9030")
onready var color = $ColorRect/Color
var spongeSelected = false
onready var sponge = $ColorRect/Sponge

func _ready():
	color.connect("colorChanged", self, "onColorChanged")
	
func _process(delta):
	if spongeSelected:
		followMouse()
	
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
			active_line.width = 10.0
			active_line.set_texture(load("res://Assets/Textures/GameCaroline/export_ready-12.png"))
			active_line.set_texture_mode(2)
			active_line.width = 50

		else:
			pressed = false
			
	if event is InputEventMouseMotion:
		if pressed:
			active_line.add_point(event.position)
			add_child(active_line)
			

func _on_Sponge_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			spongeSelected = true
		else:
			spongeSelected = false
			
				
func followMouse():
	sponge.position = get_global_mouse_position()
			
			
			
			
			
			

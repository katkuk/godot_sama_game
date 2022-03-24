extends Node2D

var pressed = false
var active_line
#onready var color = $ColorRect/Color
var spongeSelected = false
var brushSelected = true

onready var sponge = $ColorRect/Sponge
onready var originalSpongePosition = sponge.get_position()
onready var brush = $ColorRect/Brush
onready var originalBrushPosition = brush.get_position()
onready var brushTip = $ColorRect/Brush/BrushTip
onready var canvas = $Area2D
onready var particles = $ColorRect/Sponge/Particles2D

const Colore = preload("res://Scenes/Games/GameCaroline/Color.tscn")
onready var colorSpawnPoints = $ColorRect/Palette/ColorSpawnPoints
onready var colorSetOne = ["#8B58A5", "#1E1717", "#D8BBAE", "#AA645D", "#6D2541", "#D0C1D8"]
onready var currentColor = Color(colorSetOne[0])

var minigameOnScreenGUI = preload("res://Scenes/GUI/MinigameOnScreenGui.tscn")
var onScreenPopUpText = "Are you sure you want to leave the minigame?"
var onScreenYesText = "Yes"
var onScreenNoText = "No"
var onScreenGui

func generateColors() :
	var spawnpoints = colorSpawnPoints.get_children()
	var i = -1
	for color in colorSetOne:
			i = i+1
			var currentColor = Colore.instance()
			#print(currentColor.get_child(0).self_modulate)
			currentColor.get_child(0).self_modulate = color
			add_child(currentColor)
			currentColor.global_position = spawnpoints[i].global_position
			currentColor.connect("colorChanged", self, "onColorChanged")
			
func _ready():
	generateColors()
	addOnScreenGui()

func addOnScreenGui():
	onScreenGui = minigameOnScreenGUI.instance()
	onScreenGui.init(onScreenPopUpText, onScreenYesText, onScreenNoText)
	onScreenGui.connect("restartMinigame", self, "restartGame")
	add_child(onScreenGui)

func restartGame():
	print("restart minigame called")
	
func _process(delta):
	#if spongeSelected:
	followMouse()
	
func onColorChanged(message):
	currentColor = message
	brushTip.self_modulate = currentColor;
	
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			#print("clicked")
			pressed = true
			active_line = Line2D.new()
			active_line.width = 50
			active_line.set_texture(load("res://Assets/Textures/GameCaroline/export_ready-12.png"))
			active_line.set_texture_mode(2)
			if spongeSelected:
				active_line.width = 130
				currentColor = "#fefce0"
			active_line.default_color = currentColor
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
			particles.emitting = true
		else:
			spongeSelected = false
			particles.emitting = false
			sponge.set_global_position(originalSpongePosition)
				
func followMouse():
	if spongeSelected:
		sponge.position = get_global_mouse_position()
		brush.set_global_position(originalBrushPosition)
		brush.rotation_degrees = 0
	else:
		brush.position = get_global_mouse_position()
		brush.rotation_degrees = -131.6
			
			
func _on_SpongePalette_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			spongeSelected = true;
			brushSelected = false;
			$ColorRect/Palette/SpongePalette/highlightSponge.visible = true
			$ColorRect/Palette/BrushPalette/highlightBrush.visible = false
	

func _on_BrushPalette_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			spongeSelected = false;
			brushSelected = true;
			$ColorRect/Palette/SpongePalette/highlightSponge.visible = false
			$ColorRect/Palette/BrushPalette/highlightBrush.visible = true

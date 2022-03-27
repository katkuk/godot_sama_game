extends Node2D

var pressed = false
var active_line
#onready var color = $ColorRect/Color
var spongeSelected = false
var brushSelected = true

onready var brushTip = $ColorRect/Palette/BrushPalette/BrushPalette/BrushTip
onready var canvas = $Area2D
onready var particles = $ColorRect/Palette/SpongePalette/Particles2D
onready var rememberLastColor 

const Colore = preload("res://Scenes/Games/GameCaroline/Color.tscn")
onready var colorSpawnPoints = $ColorRect/Palette/ColorSpawnPoints
onready var colorSetCaroline = ["#8B58A5", "#1E1717", "#D8BBAE", "#AA645D", "#6D2541", "#D0C1D8"]
onready var currentColor = Color(colorSetCaroline[0])

var minigameOnScreenGUI = preload("res://Scenes/GUI/MinigameOnScreenGui.tscn")
var onScreenPopUpText = "Are you sure you want to leave the minigame?"
var onScreenYesText = "Yes"
var onScreenNoText = "No"
var onScreenGui


func generateColors():
	var spawnpoints = colorSpawnPoints.get_children()
	var i = -1
	for color in colorSetCaroline:
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
	brushTip.self_modulate = currentColor;

func addOnScreenGui():
	onScreenGui = minigameOnScreenGUI.instance()
	onScreenGui.init(onScreenPopUpText, onScreenYesText, onScreenNoText)
	onScreenGui.connect("restartMinigame", self, "restartGame")
	add_child(onScreenGui)

func restartGame():
	print("restart minigame called")
	
func _process(delta):
	pass
	
func onColorChanged(message):
	currentColor = message
	brushTip.self_modulate = currentColor;
	spongeSelected = false
	brushSelected = true
	particles.emitting = false;
	$ColorRect/Palette/SpongePalette/highlightSponge.visible = false
	$ColorRect/Palette/BrushPalette/highlightBrush.visible = true
	
func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
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
			
func _on_SpongePalette_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			spongeSelected = true;
			brushSelected = false;
			rememberLastColor = currentColor
			$ColorRect/Palette/SpongePalette/highlightSponge.visible = true
			$ColorRect/Palette/BrushPalette/highlightBrush.visible = false
			particles.emitting = true

func _on_BrushPalette_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			spongeSelected = false;
			brushSelected = true;
			currentColor = rememberLastColor
			$ColorRect/Palette/SpongePalette/highlightSponge.visible = false
			$ColorRect/Palette/BrushPalette/highlightBrush.visible = true
			particles.emitting = false

func _on_box1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			pass


func _on_box2_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_box3_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_box4_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_box5_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on_colorbookOptions_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$ChangeOutlinePopup.visible = !$ChangeOutlinePopup.visible


func _on_Close_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$ChangeOutlinePopup.visible = false

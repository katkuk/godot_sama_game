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
onready var colorSetCaroline = ["#8B58A5", "#1E1717", "#D8BBAE", "#AA645D", "#6D2541", "#D0C1D8", "#cda957", "#238260"]
onready var colorSetGeneral = ["#36346b", "#d8bbae", "#b58694", "#a99fa3", "#e6b24f", "#1e1717", "#a99fa3", "#ab693b"]
onready var colorSetShip = ["#1b3f67", "#5992be", "#cedfe2","#b7654b","#643331", "#eff5fb", "#b24c4f", "#c4907f"]
onready var colorSetBuilding = ["#d0c6da", "#a186ba", "#cc8360", "#18805a","#514d55", "#c2d0cc", "#6dbdd0", "#225d3e"]
onready var colorSetEmpty = ["#8B58A5", "#1E1717", "#D8BBAE", "#AA645D", "#6D2541", "#D0C1D8", "#cda957", "#238260"]

onready var currentColor = Color(colorSetCaroline[0])
onready var currentColorSet = colorSetCaroline

onready var drawing = true;

var minigameOnScreenGUI = preload("res://Scenes/GUI/MinigameOnScreenGui.tscn")
var onScreenPopUpText = "Are you sure you want to leave the minigame?"
var onScreenYesText = "Yes"
var onScreenNoText = "No"
var onScreenGui



func generateColors():
	var spawnpoints = colorSpawnPoints.get_children()
	var i = -1
	for n in $colorContainer.get_children():
		$colorContainer.remove_child(n)
		n.queue_free()
	for color in currentColorSet:
			i = i+1
			var currentColor = Colore.instance()
			#print(currentColor.get_child(0).self_modulate)
			currentColor.get_child(0).self_modulate = color
			$colorContainer.add_child(currentColor)
			currentColor.global_position = spawnpoints[i].global_position
			currentColor.connect("colorChanged", self, "onColorChanged")
	brushTip.self_modulate = currentColorSet[0];
	currentColor = currentColorSet[0]
		
func _ready():
	generateColors()
	addOnScreenGui()
	brushTip.self_modulate = currentColor;

func addOnScreenGui():
	onScreenGui = minigameOnScreenGUI.instance()
	onScreenGui.init(onScreenPopUpText, onScreenYesText, onScreenNoText)
	onScreenGui.connect("restartMinigame", self, "restartGame")
	add_child(onScreenGui)
	
onready var lines = $lines

func restartGame():
	for n in lines.get_children():
		lines.remove_child(n)
		n.queue_free()
	
	
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
			$lines.add_child(active_line)
		else:
			pressed = false
			
	if event is InputEventMouseMotion:
		if pressed && drawing:
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
			
# stupid code following xd

onready var previousColorBook = null
onready var currentColorBook = $"ChangeOutlinePopup/background/boxes/boxCaroline"
onready var onCanvas = $ColorRect/canvas/currentOutline

func _on_box1_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			previousColorBook = currentColorBook
			currentColorBook = $"ChangeOutlinePopup/background/boxes/boxCaroline"
			if previousColorBook != currentColorBook:
				restartGame()
			previousColorBook.get_node("selectedHighlight").visible = false
			currentColorBook.get_node("selectedHighlight").visible = true
			onCanvas.texture = load("res://Assets/Textures/GameCaroline/caroline.png")
			currentColorSet = colorSetCaroline
			generateColors()

func _on_box2_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			previousColorBook = currentColorBook
			currentColorBook = $"ChangeOutlinePopup/background/boxes/boxGeneral"
			if previousColorBook != currentColorBook:
				restartGame()
			previousColorBook.get_node("selectedHighlight").visible = false
			currentColorBook.get_node("selectedHighlight").visible = true
			onCanvas.texture = load("res://Assets/Textures/GameCaroline/general.png")
			currentColorSet = colorSetGeneral
			generateColors()

func _on_box3_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			previousColorBook = currentColorBook
			currentColorBook = $"ChangeOutlinePopup/background/boxes/boxBuilding"
			if previousColorBook != currentColorBook:
				restartGame()
			previousColorBook.get_node("selectedHighlight").visible = false
			currentColorBook.get_node("selectedHighlight").visible = true
			onCanvas.texture = load("res://Assets/Textures/GameCaroline/building.png")
			currentColorSet = colorSetBuilding
			generateColors()

func _on_box4_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			previousColorBook = currentColorBook
			currentColorBook = $"ChangeOutlinePopup/background/boxes/boxBoat"
			if previousColorBook != currentColorBook:
				restartGame()
			previousColorBook.get_node("selectedHighlight").visible = false
			currentColorBook.get_node("selectedHighlight").visible = true
			onCanvas.texture = load("res://Assets/Textures/GameCaroline/boat.png")
			currentColorSet = colorSetShip
			generateColors()

func _on_box5_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			previousColorBook = currentColorBook
			currentColorBook = $"ChangeOutlinePopup/background/boxes/boxEmpty"
			if previousColorBook != currentColorBook:
				restartGame()
			previousColorBook.get_node("selectedHighlight").visible = false
			currentColorBook.get_node("selectedHighlight").visible = true
			onCanvas.texture = load("res://Assets/Textures/GameCaroline/empty.png")
			currentColorSet = colorSetEmpty
			generateColors()

func _on_colorbookOptions_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$ChangeOutlinePopup.visible = !$ChangeOutlinePopup.visible
			drawing = false


func _on_Close_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$ChangeOutlinePopup.visible = false
			drawing = true

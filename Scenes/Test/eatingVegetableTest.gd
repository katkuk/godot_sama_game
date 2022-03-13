extends Node2D

onready var carrotSelected
onready var carrot = $carrot1Area
onready var carrotAnimPlayer = $carrot1Area/AnimationPlayer
onready var particles = $carrot1Area/Particles2D
onready var mouthAnim = $mouthArea/mouthAnims/mouthAnimPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	followMouse()


func _on_carrot1Area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			carrotSelected = true
			carrotAnimPlayer.play("rotate")
		else:
			carrotSelected = false
		
		 
func followMouse():
	if carrotSelected:
		carrot.position = get_global_mouse_position()


func _on_mouthArea_area_entered(area):
	particles.emitting = true
	mouthAnim.play("eating")
	carrotAnimPlayer.play("scale")
	
	
	
	
	

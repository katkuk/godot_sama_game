extends Node2D

onready var purpleCarrot = $Basket/PurpleCarrot
onready var carrotSelected
onready var originalCarrotPos = purpleCarrot.position

#func _ready():
#	purpleCarrot.position = get_global_mouse_position()

func _process(delta):
		followMouse()
	
func _on_PurpleCarrot_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		carrotSelected = true;
	else:
		print('carrotSelected = false;')
		carrotSelected = false;

func _on_mouthArea1_area_entered(area):
	pass # Replace with function body.
	
	
func followMouse():
	if carrotSelected == true:
		purpleCarrot.position = get_viewport().get_mouse_position()


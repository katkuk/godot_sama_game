extends Node2D

onready var kuna = $Kuna
enum {STAND, IDLE, WALK, INTERACT}

func _unhandled_input(event):
	#ignore all inputs other than click
	if !Input.is_action_pressed("Click"):
		return
	#kuna.is_going_to_interact = false
	kuna.destination.x = get_global_mouse_position().x #x from the click
	kuna.destination.y = kuna.position.y #always same as Kuna node
	#kuna.timer.stop() #stop the idle timer when clicking
	print("kuna script click")
	kuna.change_state(WALK)


#this is triggered when clicking on collishion shape of interaction object and will overwrite the unhandled input func
func _on_InteractionObjects_input_event(viewport, event, shape_idx):
	if !Input.is_action_pressed("Click"):
		return
	#kuna.is_going_to_interact = true
	kuna.interactable_object = $InteractionObjects.get_child(shape_idx)
	print("You clicked ", kuna.interactable_object)
	#print("coordinates ", kuna.interactable_object.get_shape().get_extents().x) #this is half of the width of the col shape
	#TO DO: position kuna on side he is closer to, make sure his tail is out of the way
	kuna.destination.x = kuna.interactable_object.position.x - kuna.interactable_object.get_shape().get_extents().x - 150
	kuna.destination.y = kuna.position.y
	kuna.change_state(INTERACT)
	
	

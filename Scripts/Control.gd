extends Node2D

onready var kuna = $Kuna
enum {STAND, IDLE, WALK, INTERACT}

func _unhandled_input(event):
	#ignore all inputs other than click
	if !Input.is_action_pressed("Click"):
		return
	kuna.destination.x = get_global_mouse_position().x #x from the click
	kuna.destination.y = kuna.position.y #always same as Kuna node
	#print("click was at " + str(get_global_mouse_position().x))
	#print("kuna script click")
	kuna.change_state(WALK)
	kuna.timer.stop()


#this is triggered when clicking on collishion shape of interaction object and will overwrite the unhandled input func
func _on_InteractionObjects_input_event(viewport, event, shape_idx):
	if !Input.is_action_pressed("Click"):
		return
	kuna.interactable_object = $InteractionObjects.get_child(shape_idx)
	print("You clicked ", kuna.interactable_object.name)
	#print("coordinates ", kuna.interactable_object.get_shape().get_extents().x) #this is half of the width of the col shape
	kuna.destination.x = kuna.interactable_object.position.x - kuna.interactable_object.get_shape().get_extents().x - 150
	kuna.destination.y = kuna.position.y
	kuna.change_state(INTERACT)
	kuna.timer.stop()
	
	
	

extends Node2D

onready var kuna = $Kuna
onready var kunaColShape = $Kuna/Collision

func _unhandled_input(event):
	if !Input.is_action_pressed("Click"):
		return
	kuna.is_going_to_interact = false
	kuna.moving = true
	kuna.destination.x = get_global_mouse_position().x #x from the click
	kuna.destination.y = kuna.position.y #always same as Kuna node
	kuna.timer.stop()
	print("kuna script click")
	#get_tree().set_input_as_handled()
	#set_process_unhandled_input(false)


func _on_InteractionObjects_input_event(viewport, event, shape_idx):
	if !Input.is_action_pressed("Click"):
		return
	kuna.is_going_to_interact = true
	
	kuna.interactable_object = $InteractionObjects.get_child(shape_idx)
	print("You clicked ", kuna.interactable_object)
	#print("coordinates ", kuna.interactable_object.get_shape().get_extents().x) #this is half of the width of the col shape
	kuna.destination.x = kuna.interactable_object.position.x - kuna.interactable_object.get_shape().get_extents().x - 150
	

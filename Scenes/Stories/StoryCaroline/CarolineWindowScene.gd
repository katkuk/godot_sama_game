extends Node2D

onready var doorRclosed = $DoorR/DoorRclosed;
onready var doorRopen = $DoorR/DoorRopen;
onready var doorLclosed = $DoorL/DoorLclosed;
onready var doorLopen = $DoorL/DoorLopen;
onready var Rclosed = true
onready var Lclosed = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
		
		

func _on_DoorR_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Window")
			if Rclosed == true:
				doorRclosed.visible = true
				doorRopen.visible = false
				Rclosed = false
			else:
				doorRclosed.visible = false
				doorRopen.visible = true
				Rclosed = true
		if Rclosed == false && Lclosed == false:
				$Caroline/WalkIn.play_backwards("walkIn")
			
func _on_DoorL_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			GlobalSound.playSound("Window")
			if Lclosed == true:
				doorLclosed.visible = true
				doorLopen.visible = false
				Lclosed = false
			else:
				doorLclosed.visible = false
				doorLopen.visible = true
				Lclosed = true
		if Rclosed == true && Lclosed == true:
				$Caroline/WalkIn.play("walkIn")
					
					
					
					

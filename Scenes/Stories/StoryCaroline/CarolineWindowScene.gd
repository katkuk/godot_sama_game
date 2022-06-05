extends Node2D

onready var doorRclosed = $DoorR/DoorRclosed;
onready var doorRopen = $DoorR/DoorRopen;
onready var doorLclosed = $DoorL/DoorLclosed;
onready var doorLopen = $DoorL/DoorLopen;
onready var Rclosed = true
onready var Lclosed = true
onready var timer = get_node("Timer")
onready var counter = 1
var CarolineIsOut = false

func _ready():
	timer.start()
	timer.connect("timeout", self, "onTimerTimeout")
	pass

func _on_DoorR_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click"):
		GlobalSound.playSound("Window")
		if Rclosed == true:
			doorRclosed.visible = false
			doorRopen.visible = true
			Rclosed = false
		else:
			doorRclosed.visible = true
			doorRopen.visible = false
			Rclosed = true
		if Rclosed == false && Lclosed == false:
			CarolineIsOut = true
			$Caroline/WalkIn.play("walkIn")
		elif Rclosed == true && Lclosed == true:
			CarolineIsOut = false
			$Caroline/WalkIn.play_backwards("walkIn")
		#print("right door closed: ", Rclosed, " left door closed: ", Lclosed)

func _on_DoorL_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("Click"):
		GlobalSound.playSound("Window")
		if Lclosed == true:
			doorLclosed.visible = false
			doorLopen.visible = true
			Lclosed = false
		else:
			doorLclosed.visible = true
			doorLopen.visible = false
			Lclosed = true
		if Rclosed == false && Lclosed == false:
			CarolineIsOut = true
			$Caroline/WalkIn.play("walkIn")
		elif Rclosed == true && Lclosed == true:
			CarolineIsOut = false
			$Caroline/WalkIn.play_backwards("walkIn")
		#print("right door closed: ", Rclosed, " left door closed: ", Lclosed)

func onTimerTimeout():
	GlobalSound.playSound("Caroline/CannonBoom")
	if counter == 1:
		get_node("Boom1/AnimationPlayer").play("boom")
		print("boom1")
	elif counter == 2:
		get_node("Boom2/AnimationPlayer").play("boom")
		print("boom2")
	else:
		get_node("Boom3/AnimationPlayer").play("boom")
		print("boom3")
	var newWait = rand_range(0.5, 3)
	timer.wait_time = newWait
	counter = counter + 1
	if counter == 4:
		counter = 1

func _on_WalkIn_animation_finished(anim_name):
	print("anim finished")
	if CarolineIsOut:
		$Caroline/Caroline.play("caroline")

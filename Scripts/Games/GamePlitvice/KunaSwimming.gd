extends KinematicBody2D

onready var kunaAP = $kuna/AnimationPlayer

var speed = Vector2(500, 0) #pixels by second
var last_mouse_pos = null


func _unhandled_input(event):
	if event.is_action_pressed("Click"):
		last_mouse_pos = get_viewport().get_mouse_position()
		#kunaAP.play("submerge")

func _physics_process(delta):
	if last_mouse_pos:
		var direction_vector = (last_mouse_pos - global_position)
		if direction_vector.length() < 3:
			#kunaAP.play_backwards("submerge")
			yield(kunaAP, "animation_finished")
			kunaAP.play("swim")
			return			
		move_and_slide(direction_vector.normalized() * speed)


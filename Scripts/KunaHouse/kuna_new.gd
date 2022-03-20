extends Area2D
enum State {UNSELECTED, SELECTED, WALKING, INTERACTING, HOLDING}
var state : int = State.UNSELECTED
var walkingDirection : String
onready var camera = get_parent().get_parent().get_node("Camera")
onready var kunaWalking = get_node("kunaWalking")
onready var kunaIdle = get_node("kunaIdle")
signal scroll

func _ready():
	change_state(State.UNSELECTED)

func _physics_process(delta):
	if state == State.SELECTED or state == State.WALKING:
		followMouse(delta)
	if state == State.UNSELECTED:
		#drop it like its hot
		global_position = lerp(global_position, Vector2(global_position.x, 1061), 2 * delta)

func followMouse(delta):
	global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if get_global_transform_with_canvas()[2].x > 1800:
		walkingDirection = "right"
		change_state(State.WALKING)
		emit_signal("scroll", "right")
	elif get_global_transform_with_canvas()[2].x < 424:
		walkingDirection = "left"
		change_state(State.WALKING)
		emit_signal("scroll", "left")
	else:
		change_state(State.SELECTED)
		emit_signal("scroll", "stop")

func _on_kuna_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			change_state(State.SELECTED)
		else:
			change_state(State.UNSELECTED)
	else:
		return

func _input(event):
	if event is InputEventKey and event.scancode == KEY_K:
		print(global_position.x)
		print(position.x)
	else:
		return

func change_state(newState):
	state = newState
	#print("kuna new state: " + str(State.keys()[state]))
	match state:
		State.UNSELECTED:
			emit_signal("scroll", "stop")
			kunaIdle.visible = true
			kunaWalking.visible = false
		State.SELECTED:
			kunaIdle.visible = true
			kunaWalking.visible = false
		State.WALKING:
			kunaIdle.visible = false
			kunaWalking.visible = true
			if walkingDirection == "left":
				kunaWalking.flip_h = true
			elif walkingDirection == "right":
				kunaWalking.flip_h = false
			kunaWalking.get_node("kunaWalkingAP").play("walking")
		State.INTERACTING:
			print(state)
		State.HOLDING:
			print(state)


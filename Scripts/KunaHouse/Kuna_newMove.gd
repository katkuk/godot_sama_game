extends Area2D
enum State {UNSELECTED, IDLING, SELECTED, WALKING, INTERACTING, HOLDING}
var state : int = State.UNSELECTED
var idleTimer = null
export(int) var max_idle_delay = 15
export(int) var min_idle_delay = 5
var walkingDirection : String
onready var camera = get_parent().get_parent().get_node("Camera")
onready var kunaWalking = get_node("kunaWalking")
onready var kunaIdle = get_node("kunaIdle")
signal scroll

func _ready():
	idleTimer = Timer.new()
	idleTimer.set_one_shot(false)
	idleTimer.connect("timeout", self, "_on_idleTimer_timeout")
	add_child(idleTimer)
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

func getRandomDelay():
	var n = randi() % (max_idle_delay - min_idle_delay) + min_idle_delay
	print("I will idle in: ",  n, "s")
	return n

func _on_idleTimer_timeout():
	print("TIME TO IDLE")
	change_state(State.IDLING)

func _on_kunaIdleAP_animation_finished(anim):
	if anim == "idle":
		change_state(State.UNSELECTED)

func change_state(newState):
	state = newState
	#print("kuna new state: " + str(State.keys()[state]))
	match state:
		State.UNSELECTED:
			idleTimer.set_wait_time(getRandomDelay())
			idleTimer.start()
			emit_signal("scroll", "stop")
			kunaIdle.visible = true
			kunaWalking.visible = false
		State.IDLING:
			kunaIdle.get_node("kunaIdleAP").get_animation("idle").set_loop(false)
			kunaIdle.get_node("kunaIdleAP").play("idle")
		State.SELECTED:
			idleTimer.stop()
			kunaIdle.get_node("kunaIdleAP").stop()
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

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
var hoveredObject
var interactingWithObject

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
	if Input.is_action_just_pressed("Click"):
		change_state(State.SELECTED)
	else:
		return

func _input(event):
	if event is InputEventMouseButton:
		#when unclicking
		if event.button_index == BUTTON_LEFT and not event.pressed:
			if hoveredObject != null:
				change_state(State.INTERACTING)
				interactingWithObject = hoveredObject
				#hoveredObject = null
			else:
				change_state(State.UNSELECTED)
#		elif Input.is_action_just_pressed("Click") and interactingWithObject != null:
#			print("state: ", state)
#			print("hovered object: ", hoveredObject)
#			print("interacting with: ", interactingWithObject)
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
			hoveredObject = null
			interactingWithObject = null
			kunaIdle.visible = true
			kunaWalking.visible = false
		State.IDLING:
			kunaIdle.get_node("kunaIdleAP").get_animation("idle").set_loop(false)
			kunaIdle.get_node("kunaIdleAP").play("idle")
		State.SELECTED:
			kunaIdle.visible = true
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
			#visible = false
			kunaIdle.visible = false
			print(state)
		State.HOLDING:
			print(state)


func _on_kuna_area_entered(area):
	if area.is_in_group("KunaObjects"):
		hoveredObject = area
		#print(hoveredObject)
		area.get_node("chairEmpty").visible = false
		area.get_node("chairWithKuna").visible = true
		kunaIdle.visible = false
	else:
		return


func _on_kuna_area_exited(area):
	if area.is_in_group("KunaObjects"):
		hoveredObject = null
		#print(hoveredObject)
		area.get_node("chairEmpty").visible = true
		area.get_node("chairWithKuna").visible = false
		kunaIdle.visible = true
	else:
		return

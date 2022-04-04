extends Area2D
enum State {UNSELECTED, IDLING, SELECTED, WALKING, HOVERING, INTERACTING, HOLDING}
var state : int = State.UNSELECTED
var idleTimer = null
export(int) var max_idle_delay = 15
export(int) var min_idle_delay = 5
var walkingDirection : String
onready var camera = get_parent().get_parent().get_node("Camera")
onready var kunaWalking = get_node("kunaWalking")
onready var kunaIdle = get_node("kunaIdle")
signal scroll
signal kunaInteracting
var hoveredObject
var interactingWithObject
export var group := "clickable"

func _ready():
	idleTimer = Timer.new()
	idleTimer.set_one_shot(false)
	idleTimer.connect("timeout", self, "_on_idleTimer_timeout")
	add_child(idleTimer)
	
	if Global.kunaSceneState.kunaState == State.INTERACTING:
		setInteractingObj(Global.kunaSceneState.kunaInteractingWith)
	change_state(Global.kunaSceneState.kunaState)
	
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	add_to_group(group)
	
	for obj in get_tree().get_nodes_in_group("KunaObjects"):
		obj.connect("kunaHovering", self, "kunaHovering")
		obj.connect("kunaUnhovered", self, "kunaUnhovered")

func mouse_entered():
	add_to_group(group + "hovered")

func mouse_exited():
	remove_from_group(group + "hovered")

func is_on_top() -> bool:
	for clickable in get_tree().get_nodes_in_group(group + "hovered"):
		if clickable.get_index() > get_index():
			return false
	return true

func _physics_process(delta):
	if state == State.SELECTED or state == State.WALKING or state == State.HOVERING:
		followMouse(delta)
	if state == State.UNSELECTED:
		#drop it like its hot
		global_position = lerp(global_position, Vector2(global_position.x, 1061), 2 * delta)

func followMouse(delta):
	global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	if state == State.HOVERING:
		change_state(State.HOVERING)
	else:
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
	if is_on_top():
		#when clicking on kuna
		if Input.is_action_just_pressed("Click"):
			change_state(State.SELECTED)
		#declicking on kuna
		elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
			#when kuna is hovering kuna object
			if hoveredObject != null:
				change_state(State.INTERACTING)
				setInteractingObj(hoveredObject.name)
				#signal to update the sprite of hovered object and update its interacting state
				emit_signal("kunaInteracting")
			#declicking on kuna when its not hovering anything
			else:
				change_state(State.UNSELECTED)
		else:
			return
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
	print("kuna new state: " + str(State.keys()[state]))
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
		State.HOVERING:
			kunaIdle.visible = false
			kunaWalking.visible = false
			for sprite in get_node("interactionSprites").get_children():
				if str(sprite.name.to_lower()) == str(hoveredObject.name.to_lower()):
					sprite.visible = true
		State.INTERACTING:
			visible = false
		State.HOLDING:
			print(state)

func kunaHovering(object):
	#print("kuna hovering over: ", object)
	if visible == false:
		visible = true
	hoveredObject = object
	change_state(State.HOVERING)

func kunaUnhovered(object):
	for sprite in get_node("interactionSprites").get_children():
				if str(sprite.name.to_lower()) == str(object.name.to_lower()):
					sprite.visible = false
	hoveredObject = null
	change_state(State.SELECTED)

func setInteractingObj(objName):
	for obj in get_tree().get_nodes_in_group("KunaObjects"):
		if obj.name == objName:
			interactingWithObject = obj
	hoveredObject = null

extends KinematicBody2D

export(int) var max_speed = 900
export(int) var acceleration = 1200
export(int) var max_idle_delay = 15
export(int) var min_idle_delay = 5
var speed = 0
var move_direction
var moving = false #boolean that will activate movement and reset speed to 0 if players is standing still
var destination = Vector2() #location where the mouse click happened
var movement = Vector2() #the movement that we will push to the engine
onready var animatedSprite = $AnimatedSprite
onready var camera = get_parent().get_node("Camera2D")
var timer = null
export(bool) var kunaSceneIsActive = true
var interactable_object
enum {STAND, IDLE, WALK, INTERACT}
var state = STAND
var is_going_to_interact : bool

# Called when the node enters the scene tree for the first time
func _ready():
	print("adding idle timer")
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)
	change_state(STAND)
	

func _physics_process(delta): #every second
	if kunaSceneIsActive == true:
		MovementLoop(delta)

func MovementLoop(delta):
	match state:
		STAND:
			speed = 0
		IDLE:
			speed = 0
		WALK:
			move_to_destination(delta)
		INTERACT:
			speed = 0

func move_to_destination(delta):
	#print("STATE IS: " + str(state))
	if destination.x < position.x:
		animatedSprite.flip_h = true
	elif destination.x > position.x:
		animatedSprite.flip_h = false

	speed += acceleration * delta
	if speed > max_speed:
		speed = max_speed

	movement = position.direction_to(destination) * speed
	if position.distance_to(destination) > 10:
		movement = move_and_slide(movement)
	else:
		if is_going_to_interact:
			interactable_object.interact()
			change_state(INTERACT)
		else:
			change_state(STAND)

func getRandomDelay():
	var n = randi() % (max_idle_delay - min_idle_delay) + min_idle_delay
	print("I will idle in: ",  n, "s")
	return n

func _on_Timer_timeout():
	print("TIME TO IDLE")
	change_state(IDLE)

func _on_AnimatedSprite_animation_finished():
	if animatedSprite.animation == "Idle":
		change_state(STAND)

func change_state(newState):
	state = newState
	match state:
		STAND:
			timer.set_wait_time(getRandomDelay())
			timer.start()
			animatedSprite.play("Stand")
		IDLE:
			animatedSprite.play("Idle")
		WALK:
			animatedSprite.play("Walk")
		INTERACT:
			animatedSprite.play("Stand")

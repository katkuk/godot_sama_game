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
onready var camera = $Camera2D
var can_idle = false
var timer = null
export(bool) var kunaSceneIsActive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if moving == false:
		print("adding timer")
		timer = Timer.new()
		timer.set_wait_time(getRandomDelay())
		timer.set_one_shot(false)
		timer.connect("timeout", self, "_on_Timer_timeout")
		add_child(timer)
		timer.start()

func _unhandled_input(event):
	if event.is_action_pressed("Click"):
		moving = true
		destination.x = get_global_mouse_position().x #x from the click
		destination.y = position.y #always same as Kuna node
		timer.stop()

func _physics_process(delta): #every second
	if kunaSceneIsActive == true:
		MovementLoop(delta)

func MovementLoop(delta):
	if moving == false && can_idle == true:
		speed = 0
		animatedSprite.animation = "Idle"
	elif moving == false && can_idle == false:
		speed = 0
		animatedSprite.animation = "Stand"

	elif moving == true:
		if destination.x < position.x:
			#Kuna walking left
			animatedSprite.animation = "Walk"
			animatedSprite.flip_h = true
			
		elif destination.x > position.x:
			#Kuna walking right
			animatedSprite.animation = "Walk"
			animatedSprite.flip_h = false
			
		speed += acceleration * delta
		if speed > max_speed:
			speed = max_speed
	
	movement = position.direction_to(destination) * speed
	if position.distance_to(destination) > 10:
		movement = move_and_slide(movement)
	else:
		moving = false

func _on_Timer_timeout():
	print("TIME TO IDLE")
	can_idle = true
	timer.set_wait_time(getRandomDelay())
	timer.start()

func _process(_delta): #runs as often as it can
	pass

func getRandomDelay():
	var n = randi() % (max_idle_delay - min_idle_delay) + min_idle_delay
	print("I will idle in: ",  n, "s")
	return n

func _on_AnimatedSprite_animation_finished():
	if animatedSprite.animation == "Idle":
		can_idle = false
	elif animatedSprite.animation == "Walk":
		timer.set_wait_time(getRandomDelay())
		timer.start()
		
		
	

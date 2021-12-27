extends KinematicBody2D

export(int) var max_speed = 900
var speed = 0
export(int) var acceleration = 1200
var move_direction
var moving = false #boolean that will activate movement and reset speed to 0 if players is standing still
var destination = Vector2() #location where the mouse click happened
var movement = Vector2() #the movement that we will push to the engine
onready var animatedSprite = $AnimatedSprite

func _input(_event): #change this to unhandled input later
	if Input.is_action_pressed("Click"):
		moving = true
		destination.x = get_global_mouse_position().x #x from the click
		destination.y = position.y #always same as Kuna node

func _physics_process(delta): #every second
	MovementLoop(delta)

func MovementLoop(delta):
	if moving == false:
		speed = 0
		animatedSprite.animation = "Stand"
		
		randomize()
		var t = rand_range(50,200)
		yield(get_tree().create_timer(t),"timeout")

	else:
		if destination.x < position.x:
			#move_direction = "Left"
			animatedSprite.animation = "Walk"
			animatedSprite.flip_h = true
		elif destination.x > position.x:
			#move_direction = "Right"
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

func _process(_delta): #runs as often as it can
	pass

#func AnimationLoop():
#	var anim_direction 
#	var anim_mode = "Idle"
#	var animation
#
#	if moving == true:
#		anim_mode = "Walk"
#		animation = anim_mode + "_" + anim_direction
#		print(animation);
#	elif moving == false:
#		anim_mode = "Idle"
#		animation = anim_mode
#	get_node("AnimationPlayer").play(animation)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


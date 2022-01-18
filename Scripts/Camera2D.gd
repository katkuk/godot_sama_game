extends Camera2D

export (float) var lerp_speed = 0.1
onready var player = get_parent().get_node("Kuna")
onready var map = get_parent().get_node("InteractionObjects/Map_CollishionShape")
var target = null

const LOOK_AHEAD_FACTOR = 0.2
var facing = 0
onready var prev_camera_pos = get_camera_position()
var target_offset = 0

const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 0.5
onready var tween = $ShiftTween
var can_zoom : bool

var zoom_min = Vector2(.200001, .200001)
var zoom_max = Vector2(2,2)
var zoom_speed = Vector2(.2,.2)


func _ready():
	target = player
	print("ready camera " + str(prev_camera_pos))
	self.set_position(Vector2(target.get_position().x, player.get_position().y))
	
	#connect signal from interaction objects group
	for object in get_tree().get_nodes_in_group("InteractionObjects"):
		object.connect("focus", self, "set_camera")

func _physics_process(delta):
	print(can_zoom)
	#if the target is player move with offset, if its object we want to center the camera 
	if target == player:
		_check_facing()
		prev_camera_pos = get_camera_position()
#		tween.interpolate_property(self, "position:x", position.x, target.get_position().x + target_offset, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
#		tween.start()
		self.set_position(Vector2(target.get_position().x + target_offset, player.get_position().y))
	else:
		tween.interpolate_property(self, "position:x", position.x, target.get_position().x, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		tween.start()
		self.set_position(Vector2(target.get_position().x, player.get_position().y))

func _check_facing():
	#this will set new_facing as -1 if camera moved left, 0 if it didnt move and 1 if it moved right
	var new_facing = sign(get_camera_position().x - prev_camera_pos.x) 
	#if camera has moved to a new direction
	if new_facing != 0 && facing !=  new_facing:
		#set facing to the new direction
		facing = new_facing
		#calculate offset based on the viewport size
		target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		#print("target offset is: " + str(target_offset))

func set_camera(object):
	print("camera set")
	target_offset = 0
	target = object
	
	print("camera is at x: ", str(target.get_position().x))
	if str(object.name) == "Map_CollishionShape":
		can_zoom = true

func release_camera():
	print("camera released")
	target_offset = 0
	target = player
	if can_zoom:
		can_zoom = !can_zoom

func _unhandled_input(event):
	if !can_zoom:
		return
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				#print("zooming in")
				if zoom > zoom_min:
					zoom -= zoom_speed
			if event.button_index == BUTTON_WHEEL_DOWN:
				#print("zooming out")
				if zoom < zoom_max:
					zoom += zoom_speed
				

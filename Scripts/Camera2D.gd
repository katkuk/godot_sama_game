extends Camera2D

export (float) var lerp_speed = 0.1
onready var player = get_parent().get_node("Kuna")
onready var map = get_parent().get_node("InteractionObjects/Map_CollishionShape")
var target = null


func _ready():
	target = player
	
	#connect signal from interaction objects group
	for object in get_tree().get_nodes_in_group("InteractionObjects"):
		object.connect("focus", self, "set_camera")
		object.connect("unfocus", self, "release_camera")


func _physics_process(delta):
	self.set_position(Vector2(target.get_position().x, player.get_position().y))
	

func set_camera(object):
	print("camera set")
	target = object

func release_camera():
	print("camera released")
	target = player

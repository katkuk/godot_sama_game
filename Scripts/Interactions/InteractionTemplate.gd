extends CollisionShape2D
signal focus
var is_active : bool

func _ready():
	for icon in get_tree().get_nodes_in_group("MapIcons"):
		icon.visible = false

func interact():
	print("TIME TO INTERACT")
	emit_signal("focus", self)
	is_active = true
	
	for icon in get_tree().get_nodes_in_group("MapIcons"):
		icon.visible = true


func leaveInteraction():
	is_active = false
	for icon in get_tree().get_nodes_in_group("MapIcons"):
		icon.visible = false

extends CollisionShape2D
signal focus
signal displayPlayBtn
var is_active : bool

func _ready():
	pass

func interact():
	print("TIME TO INTERACT")
	emit_signal("focus", self)
	emit_signal("displayPlayBtn", self)
	is_active = true


func leaveInteraction():
	is_active = false

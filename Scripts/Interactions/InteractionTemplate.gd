extends CollisionShape2D

onready var camera = $Camera2D
signal focus
signal unfocus

func interact():
	print("TIME TO INTERACT")
	emit_signal("focus", self)



func leaveInteraction():
	emit_signal("unfocus", self)

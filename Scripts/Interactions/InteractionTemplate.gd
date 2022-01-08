extends CollisionShape2D

signal focus

func interact():
	print("TIME TO INTERACT")
	emit_signal("focus", self)


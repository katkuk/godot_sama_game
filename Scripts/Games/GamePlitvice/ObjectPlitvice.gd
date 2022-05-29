extends Area2D

export var collectable : bool
var collidedWithKuna : bool = false

func _ready():
	pass

func init(c):
	collectable = c

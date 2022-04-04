extends Area2D

export (bool) var hovered = false
export (bool) var interacting = false
export (NodePath) var interactingSpritePath
export (NodePath) var defaultSpritePath
onready var interactingSprite = get_node(interactingSpritePath)
onready var defaultSprite = get_node(defaultSpritePath)
onready var kuna = get_parent().get_parent().get_node("Kuna")
signal kunaHovering
signal kunaUnhovered

func _ready():
	connect("area_entered", self, "area_entered")
	connect("area_exited", self, "area_exited")
	kuna.connect("kunaInteracting", self, "kunaInteracting")
	connect("input_event", self, "on_input_event")

func area_entered(area):
	if area.name.to_lower() == "kuna":
		setHovered(true)
		emit_signal("kunaHovering", self)
	else:
		return

func area_exited(area):
	if area.name.to_lower() == "kuna":
		setHovered(false)
		emit_signal("kunaUnhovered")
	else:
		return

func kunaInteracting():
	if hovered:
		setInteracting(true)
		defaultSprite.visible = false
		interactingSprite.visible = true

func on_input_event(viewport, event, shape_idx):
	if interacting and Input.is_action_just_pressed("Click"):
		setInteracting(false)
		setHovered(true)
		defaultSprite.visible = true
		interactingSprite.visible = false
		emit_signal("kunaHovering", self)
	else:
		return

func setHovered(h):
	hovered = h

func setInteracting(i):
	interacting = i

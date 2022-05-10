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
export var group := "clickable"

func _ready():
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")
	add_to_group(group)
	
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
		emit_signal("kunaUnhovered", self)
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

func setStateInteracting():
	setInteracting(true)
	get_node(interactingSpritePath).visible = true
	get_node(defaultSpritePath).visible = false

func mouse_entered():
	add_to_group(group + "hovered")

func mouse_exited():
	remove_from_group(group + "hovered")

func is_on_top() -> bool:
	for clickable in get_tree().get_nodes_in_group(group + "hovered"):
		if clickable.get_index() > get_index():
			return false
	return true


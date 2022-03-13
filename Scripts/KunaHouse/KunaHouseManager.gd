extends Node2D

onready var kuna = get_parent().get_node("Kuna")
onready var camera = get_parent().get_node("Camera2D")
onready var interactionObjects = get_parent().get_node("InteractionObjects")
enum {STAND, IDLE, WALK, INTERACT}
var playMinigameScreen = preload("res://Scenes/GUI/PlayMinigameScreen.tscn")

func _ready():
	for object in get_tree().get_nodes_in_group("InteractionObjects"):
		object.connect("displayPlayBtn", self, "displayPlayBtn")

#this is triggered when clicking on collishion shape of interaction object and will overwrite the unhandled input
func _on_InteractionObjects_input_event(viewport, event, shape_idx):
	if !event.is_action_pressed("Click"):
		return
	kuna.interactable_object = interactionObjects.get_child(shape_idx)
	print("You clicked ", kuna.interactable_object.name)
	#print("coordinates ", kuna.interactable_object.get_shape().get_extents().x) #this is half of the width of the col shape
	kuna.destination.x = kuna.interactable_object.position.x - kuna.interactable_object.get_shape().get_extents().x - 150
	kuna.destination.y = kuna.position.y
	kuna.is_going_to_interact = true
	kuna.change_state(WALK)
	kuna.timer.stop()

func displayPlayBtn(obj):
	print("display btn")
	print(obj.name)
	var playBtn = playMinigameScreen.instance()
	get_parent().add_child(playBtn)

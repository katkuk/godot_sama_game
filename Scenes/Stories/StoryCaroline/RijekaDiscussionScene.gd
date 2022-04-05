extends Node2D

onready var generalAP = $General/General
onready var carolineAP = $Caroline/Caroline
const Bubble = preload("res://Scenes/Stories/StoryCaroline/SpeechBubble.tscn")
onready var bubblePositions = get_node("bubblePositions").get_children()


# Called when the node enters the scene tree for the first time.
func _ready():
	generalAP.play("movement")
	var bubble = Bubble.instance()
	bubble.position = bubblePositions[0].position
	$bubbles.add_child(bubble)
	

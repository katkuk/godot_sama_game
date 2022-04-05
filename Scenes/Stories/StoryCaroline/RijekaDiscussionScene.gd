extends Node2D

onready var generalAP = $General/General
onready var carolineAP = $Caroline/Caroline
const Bubble = preload("res://Scenes/Stories/StoryCaroline/SpeechBubble.tscn")
onready var bubblePositions = get_node("bubblePositions").get_children()
const BubbleParticles = preload("res://Scenes/Stories/StoryCaroline/particlesBubble.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	createBubble()

var positionCount = 0
var spriteCount = 0

func createBubble():
	var bubble = Bubble.instance()
	bubble.connect("bubbleClicked", self, "onBubbleClicked")
	bubble.position = bubblePositions[positionCount].global_position
	var spriteOptions = bubble.get_node("spriteOptions").get_children()
	spriteOptions[spriteCount].visible = true
	if positionCount == 0 or positionCount == 2 or positionCount == 4 or positionCount == 6:
		generalAP.play("movement")
		bubble.get_node("triangleGeneral").visible = true;
		bubble.get_node("triangleCaroline").visible = false;
	if positionCount == 1 or positionCount == 3 or positionCount == 5 or positionCount == 7:
		carolineAP.play("talking")
		bubble.get_node("triangleGeneral").visible = false;
		bubble.get_node("triangleCaroline").visible = true;
	$bubbles.add_child(bubble)
	spriteCount = spriteCount + 1
	positionCount = positionCount + 1
	if spriteCount < 8:	
		yield(get_tree().create_timer(2.0), "timeout")
		createBubble()
		
var bubbleClickCounter = 0
		
func onBubbleClicked():
	print(bubbleClickCounter)
	bubbleClickCounter = bubbleClickCounter + 1
	var bubbleParticles = BubbleParticles.instance()
	add_child(bubbleParticles)
	bubbleParticles.position = self.position
	bubbleParticles.emitting = true
	bubbleParticles.position = get_global_mouse_position()
	if bubbleClickCounter == 8:
		print("insert success graphics")


	

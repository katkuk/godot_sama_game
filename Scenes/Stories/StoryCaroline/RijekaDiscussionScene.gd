extends Node2D

onready var generalAP = $General/General
onready var carolineAP = $Caroline/Caroline
const Bubble = preload("res://Scenes/Stories/StoryCaroline/SpeechBubble.tscn")
onready var bubblePositions = get_node("bubblePositions").get_children()
const BubbleParticles = preload("res://Scenes/Stories/StoryCaroline/particlesBubble.tscn")

var positionCount = 0
var spriteCount = 0
var bubbleClickCounter = 0

onready var showedLastBubble = false;

func _process(delta):
	if bubbleClickCounter == 8 && showedLastBubble == false:
		showLastBubble()
		yield(get_tree().create_timer(0.7), "timeout")
		$Gibberish/G8.play()
		generalAP.play("movement")
		yield(generalAP, "animation_finished")
		$General/generalFace/eyesGeneral2.set_frame(18)
		$Caroline/carolineFace/eyesCaroline2.set_frame(17)

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	createBubble()
	GlobalSound.playSound("Sea")

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
	if positionCount == 0:
		$Gibberish/G1.play()
	if positionCount == 1:
		$Gibberish/C2.play()
	if positionCount == 2:
		$Gibberish/G3.play()
	if positionCount == 3:
		$Gibberish/C4.play()
	if positionCount == 4:
		$Gibberish/G5.play()
	if positionCount == 5:
		$Gibberish/C1.play()
	if positionCount == 6:
		$Gibberish/G6.play()
	if positionCount == 7:
		$Gibberish/C2.play()
				
	$bubbles.add_child(bubble)
	spriteCount = spriteCount + 1
	positionCount = positionCount + 1
	if spriteCount < 8:
		yield(get_tree().create_timer(2.0), "timeout")
		createBubble()
	
		
	

func onBubbleClicked():
	print(bubbleClickCounter)
	GlobalSound.playSound("Pop")
	bubbleClickCounter = bubbleClickCounter + 1
	var bubbleParticles = BubbleParticles.instance()
	add_child(bubbleParticles)
	bubbleParticles.position = self.position
	bubbleParticles.emitting = true
	bubbleParticles.position = get_global_mouse_position()
	
func showLastBubble():
	showedLastBubble = true
	yield(get_tree().create_timer(0.5), "timeout")
	$FinalSpeechBubble.visible = true
	#$FinalSpeechBubble.visible = false
	$FinalSpeechBubble/Confetti.visible = true;
	$FinalSpeechBubble/Confetti.emitting = true



	

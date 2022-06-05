extends Area2D
class_name MemoryCardNew
onready var cardAnimationPlayer = get_node("Card/CardAnimation")
onready var suitAnimationPlayer = get_node("Suit/SuitAnimation")
onready var suitSprite = get_node("Suit")
onready var cardSprite = get_node("Card")
onready var MemoryGameManager = get_parent().get_parent().get_parent()
#suit is int value 1-5, reffers to the image e.g. cloud, witch etc
var suit
#value is 1-2, because we need 2 identical cards from each suit
var value
var matched

#constructor
func init(var s, var v):
	suit = s
	value = v
	matched = false

func _ready():
	#print(MemoryGameManager)
	cardAnimationPlayer.play("fadein")
	suitSprite.modulate = Color(255,255,255,0)
	var anim = suitAnimationPlayer.get_animation("animate")
	anim.set_loop(true)

func _on_MemoryCard_input_event(viewport, event, shape_idx):
	#print(event)
	if !event.is_action_pressed("Click"):
		return
	MemoryGameManager.chooseCard(self)

func flip():
	#print("Flipped card suit: " + str(suit) + ", and value: " + str(value))
	input_pickable = false
	if cardSprite.get_frame() == 0:
		cardAnimationPlayer.play("flip")
		yield(cardAnimationPlayer, "animation_finished")
		suitAnimationPlayer.play("fadein")
	else:
		suitAnimationPlayer.play_backwards("fadein")
		cardAnimationPlayer.play_backwards("flip")
		input_pickable = true

func wasMatched():
	#cardAnimationPlayer.play_backwards("fadein")
	#GlobalSound.get_node("Plitvice/CollectSoft").play()
	if !GlobalSound.get_node("Klek/Cards/Card_" + str(suit)).is_playing():
		GlobalSound.get_node("Klek/Cards/Card_" + str(suit)).play()
	cardSprite.set_modulate(Color(0, 0, 0, 0))
	suitAnimationPlayer.play("animate")

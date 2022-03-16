extends Area2D
onready var cardAnimationPlayer = get_node("Card/CardAnimation")
onready var suitAnimationPlayer = get_node("Card/Suit/SuitAnimation")
onready var suit = get_node("Card/Suit")
onready var card = get_node("Card")
onready var MemoryGameManager = get_tree().get_root().get_node("MemoryGame/Game")

func _ready():
	cardAnimationPlayer.play("fadein")
	suit.modulate = Color(255,255,255,0)

func _on_MemoryCard_input_event(viewport, event, shape_idx):
	#print(event)
	if !event.is_action_pressed("Click"):
		return
	MemoryGameManager.chooseCard(self)


func flip():
	if card.get_frame() == 0:
		cardAnimationPlayer.play("flip")
		yield(cardAnimationPlayer, "animation_finished")
		suitAnimationPlayer.play("fadein")
	else:
		suitAnimationPlayer.play_backwards("fadein")
		cardAnimationPlayer.play_backwards("flip")

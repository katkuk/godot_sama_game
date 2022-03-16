extends Control

onready var Grid = $GridContainer
var deck = Array()
var positions = Array()
#cards to compare when flipped
var card1 
var card2
var matchTimer = Timer.new()
var flipTimer = Timer.new()
var score = 0
var scoreText
var restartBtn
var shuffleBtn

func _ready():
	getPositions()
	fillDeck()
	shuffleDeck()
	dealDeck()
	setupTimers()
	setupHUD()

func restartMemoryGame():
	for c in range(deck.size()):
		deck[c].queue_free()
	deck.clear() #deletes the pointer to the deck
	score = 0
	scoreText.text = str(score) + " from " + str(deck.size()/2)
	fillDeck()
	shuffleDeck()
	dealDeck()

func setupHUD():
	scoreText = get_node('MemoryGameHUD/Panel/Columns/ScoreColumn/Score')
	scoreText.text = str(score) + " from " + str(deck.size()/2)
	restartBtn = get_node('MemoryGameHUD/Panel/Columns/BtnsColumn/RestartGameBtn')
	shuffleBtn = get_node('MemoryGameHUD/Panel/Columns/BtnsColumn/ShuffleGameBtn')
	restartBtn.connect("pressed", self, "restartMemoryGame")
	shuffleBtn.connect("pressed", self, "reshuffleDeck")

func setupTimers():
	flipTimer.connect("timeout", self, "turnOverCards")
	flipTimer.set_one_shot(true)
	add_child(flipTimer)
	
	matchTimer.connect("timeout", self, "matchCardsAndScore")
	matchTimer.set_one_shot(true)
	add_child(matchTimer)

func getPositions():
	positions = Grid.get_children()

func fillDeck():
	var s = 1
	var v = 1
	while v < 3:
		s = 1
		while s < 6:
			deck.append("res://Scenes/Games/GameKlek/MemoryCards/MemoryCard"+str(s)+".tscn")
			s += 1
		v += 1

func shuffleDeck():
	randomize()
	deck.shuffle()

func reshuffleDeck():
	print("TIME TO RESHUFFLE!")
	for c in range(deck.size()):
		if deck[c].matched == false:
			print(deck[c].value)

func dealDeck():
	var i = -1
	for card in deck:
		i = i+1
		var klekCard = load(card).instance()
		positions[i].add_child(klekCard)

func chooseCard(var c):
	if card1 == null:
		card1 = c
		card1.flip()
		#card1.set_disabled(true)
	elif card2 == null:
		card2 = c
		card2.flip() 
		#card2.set_disabled(true)
		checkCards()

func checkCards():
	if card1.suit == card2.suit:
		matchTimer.start(1)
	else:
		flipTimer.start(1)

func turnOverCards():
	card1.flip()
	card2.flip()
	#card1.set_disabled(false)
	#card2.set_disabled(false)
	card1 = null
	card2 = null

func matchCardsAndScore():
	score += 1
	scoreText.text = str(score) + " from " + str(deck.size()/2)
	card1.set_modulate(Color(0.6, 0.6, 0.6, 0.75))
	card2.set_modulate(Color(0.6, 0.6, 0.6, 0.75))
	card1.matched = true
	card2.matched = true
	card1 = null
	card2 = null
	
	if score == deck.size()/2:
		restartMemoryGame()





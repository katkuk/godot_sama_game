extends Control

onready var Grid = $GridContainer
var deck = Array()
var deckArgs = Array()
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
var minigameIntroPopUp = preload("res://Scenes/GUI/MinigameIntroPopUp.tscn")
var minigameWinPopUp = preload("res://Scenes/GUI/MinigameWinPopUp.tscn")
var minigameOnScreenGUI = preload("res://Scenes/GUI/MinigameOnScreenGui.tscn")
var introText = "Help to wake up Klek by finding all the card pairs!"
var winText = "You did it!"
var onScreenPopUpText = "Are you sure you want to leave the minigame?"
var onScreenYesText = "Yes"
var onScreenNoText = "No"
var onScreenGui

func _ready():
	if !GlobalSound.get_node("BgSounds/KlekSnoring").is_playing():
		GlobalSound.get_node("BgSounds/KlekSnoring").play()
	displayIntroPopup()
	addOnScreenGui()
	onScreenGuiVisible(false)

func displayIntroPopup():
	var introPopUp = minigameIntroPopUp.instance()
	introPopUp.init(introText, "klek")
	introPopUp.connect("startMinigame", self, "startGame")
	add_child(introPopUp)

func displayWinPopUp():
	var winPopUp = minigameWinPopUp.instance()
	winPopUp.init(winText, "klek")
	winPopUp.connect("restartMinigame", self, "restartGame")
	add_child(winPopUp)

func addOnScreenGui():
	onScreenGui = minigameOnScreenGUI.instance()
	onScreenGui.init(onScreenPopUpText, onScreenYesText, onScreenNoText)
	onScreenGui.connect("restartMinigame", self, "restartGame")
	add_child(onScreenGui)

func onScreenGuiVisible(visible):
	onScreenGui.visible = visible

func startGame():
	onScreenGuiVisible(true)
	getPositions()
	shufflePositions()
	dealDeck()
	setupTimers()
	setupHUD()

func restartGame():
	if !GlobalSound.get_node("BgSounds/KlekSnoring").is_playing():
		GlobalSound.get_node("BgSounds/KlekSnoring").play()
	GlobalSound.stopAllCardSounds()
	onScreenGuiVisible(true)
	for c in range(positions.size()):
		positions[c].get_child(0).queue_free()
	positions.clear()
	score = 0
	scoreText.text = str(score) + " from " + str(positions.size()/2)
	getPositions()
	shufflePositions()
	dealDeck()

func setupHUD():
	scoreText = get_node('MemoryGameHUD/Panel/Columns/ScoreColumn/Score')
	scoreText.text = str(score) + " from " + str(positions.size()/2)

func setupTimers():
	flipTimer.connect("timeout", self, "turnOverCards")
	flipTimer.set_one_shot(true)
	add_child(flipTimer)
	
	matchTimer.connect("timeout", self, "matchCardsAndScore")
	matchTimer.set_one_shot(true)
	add_child(matchTimer)

func getPositions():
	positions = Grid.get_children()

func shufflePositions():
	randomize()
	positions.shuffle()

func dealDeck():
	var s = 1
	var v = 1
	var c = 0
	while v < 3:
		s = 1
		while s < 6:
			var klekCard = load("res://Scenes/Games/GameKlek/MemoryCards/MemoryCard"+str(s)+".tscn").instance()
			klekCard.init(s,v)
			positions[c].add_child(klekCard)
			if c < 5:
				c += 1
			else:
				c = 5 + s
			s += 1
		v += 1

func chooseCard(var c):
	if card1 == null:
		card1 = c
		card1.flip()
	elif card2 == null:
		card2 = c
		card2.flip() 
		checkCards()

func checkCards():
	if card1.suit == card2.suit:
		matchTimer.start(1)
	else:
		flipTimer.start(1)

func turnOverCards():
	card1.flip()
	card2.flip()
	card1 = null
	card2 = null

func matchCardsAndScore():
	score += 1
	scoreText.text = str(score) + " from " + str(deck.size()/2)
	card1.matched = true
	card1.wasMatched()
	card2.matched = true
	card2.wasMatched()
	card1 = null
	card2 = null
	if score == positions.size()/2:
		onScreenGuiVisible(false)
		GlobalSound.get_node("BgSounds/KlekSnoring").stop()
		displayWinPopUp()

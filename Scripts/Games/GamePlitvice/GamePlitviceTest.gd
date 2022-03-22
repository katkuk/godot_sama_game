extends Node2D

onready var ingredientPositions = $requiredIngPositions
onready var waterfallOptionsGroup = $waterfallOptions
onready var kunaAP = $Kuna/kuna/AnimationPlayer

var currentPath
var ingredientArray = []
var requiredIngrediendArray = []
var branches = []
var positionedRequiredIngredients = []
var branchCounter #between 2 and 4 - how many branches fall until an ingredient falls
var timer

var minigameIntroPopUp = preload("res://Scenes/GUI/MinigameIntroPopUp.tscn")
var minigameWinPopUp = preload("res://Scenes/GUI/MinigameWinPopUp.tscn")
var introText = "Enjoy Plitvice time!"
var winText = "You did it!"
	
func _ready():
	setupVars()
	setupTimer()
	displayIntroPopup()

func setupVars():
	for n in range(1,5):
		var branchScene = "res://Scenes/Games/GamePlitvice/branches/branch"+str(n)+".tscn"
		branches.push_front(branchScene)
	
	for n in range(1,11):
		var ingredientScene = "res://Scenes/Games/GamePlitvice/ingredients/ingredient"+str(n)+".tscn"
		ingredientArray.push_front(ingredientScene)

	randomize()
	ingredientArray.shuffle()
	requiredIngrediendArray = ingredientArray.slice(0,4,1)
	setBranchCounter()

func setupTimer():
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.wait_time = 4
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)

func displayIntroPopup():
	var introPopUp = minigameIntroPopUp.instance()
	introPopUp.init(introText, "plitvice")
	introPopUp.connect("startMinigame", self, "startGame")
	add_child(introPopUp)

func startGame():
	loadRequiredIngredients()
	timer.start()

func _on_timer_timeout():
	generateFallingIngredients()

func restartGame():
	setupVars()
	loadRequiredIngredients()
	timer.start()

func loadRequiredIngredients():
	var positions = ingredientPositions.get_children()
	var i = -1
	for position in positions:
		i = i+1
		var ingredient = load(requiredIngrediendArray[i]).instance()
		ingredient.scale = Vector2(0.4, 0.4)
		add_child(ingredient)
		positionedRequiredIngredients.push_front(ingredient)
		ingredient.global_position = position.global_position

func generateFallingIngredients():
	var waterfallOptions = waterfallOptionsGroup.get_children()
	var object
	randomize()
	requiredIngrediendArray.shuffle()
	randomize()
	waterfallOptions.shuffle()
	
	if branchCounter > 0:
		var whichBranch = [0,1,2,3]
		randomize()
		whichBranch.shuffle()
		object = branches[whichBranch[0]]
		branchCounter = branchCounter - 1
	else:
		object = requiredIngrediendArray[0]
		setBranchCounter()
	
	animateFallingObject(waterfallOptions[0], object)

func setBranchCounter():
	var branchCounterOptions = [2,3,4]
	#var branchCounterOptions = [1]
	randomize()
	branchCounterOptions.shuffle()
	branchCounter = branchCounterOptions[0]
	#print("new branch counter:" + str(branchCounter))
	
func animateFallingObject(waterfallOption, object):
	#print(str(object)+ " is falling")
	var newPathFollow = PathFollow2D.new()
	waterfallOption.add_child(newPathFollow)
	currentPath = newPathFollow
	var fallingIngredient = load(object).instance()
	fallingIngredient.scale = Vector2(0.4, 0.4)
	currentPath.add_child(fallingIngredient)
	#createAnimationplayer and animation
	var animationPlayer = AnimationPlayer.new()
	var animation = Animation.new()
	currentPath.add_child(animationPlayer)
	animation.set_length(1)
	animation.add_track(0)
	#print("path to follow: " + str(newPathFollow.get_path()))
	animation.track_set_path(0, str(newPathFollow.get_path()) +"/:unit_offset")
	animation.track_insert_key(0,0.0,0.0)
	animation.track_insert_key(0,1.0,1.0)
	animationPlayer.add_animation("falling", animation)
	animationPlayer.set_speed_scale(0.2)
	animationPlayer.play("falling")
	#handleRemovingErrything
	yield(animationPlayer, "animation_finished")
	newPathFollow.queue_free()

func _on_kunaArea2D_area_entered(area):
	if requiredIngrediendArray.has(area.filename):
		for ing in positionedRequiredIngredients:
			if ing.filename == area.filename:
				ing.get_child(0).visible = true
				var ingSceneName = "res://Scenes/Games/GamePlitvice/ingredients/"+ing.name+".tscn"
				requiredIngrediendArray.erase(ingSceneName)
				if requiredIngrediendArray == []:
					resetVars()
					displayWinPopUp()
	else:
		print("NOP")
		kunaAP.play("bonk")
		yield(kunaAP, "animation_finished")
		kunaAP.play("swim")

func resetVars():
	branches.clear()
	ingredientArray.clear()
	timer.stop()
	for ing in positionedRequiredIngredients:
		ing.get_child(0).visible = false
		ing.queue_free()
	positionedRequiredIngredients.clear()

func displayWinPopUp():
	var winPopUp = minigameWinPopUp.instance()
	winPopUp.init(winText, "plitvice")
	winPopUp.connect("restartMinigame", self, "restartGame")
	add_child(winPopUp)

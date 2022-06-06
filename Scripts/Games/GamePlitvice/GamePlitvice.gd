extends Node2D

onready var ingredientPositions = $requiredIngPositions
onready var waterfallOptionsGroup = $waterfallOptions
onready var kunaAP = $Kuna/kuna/AnimationPlayer

var currentPath
var ingredientArray = []
var requiredIngrediendArray = []
var branches = []
var positionedRequiredIngredients = []
var allFallingNow = []
var branchCounter #between 2 and 4 - how many branches fall until an ingredient falls
var timer

var minigameIntroPopUp = preload("res://Scenes/GUI/MinigameIntroPopUp.tscn")
var minigameWinPopUp = preload("res://Scenes/GUI/MinigameWinPopUp.tscn")
var minigameOnScreenGUI = preload("res://Scenes/GUI/MinigameOnScreenGui.tscn")
var bloop = preload("res://Scenes/Games/GamePlitvice/bloop.tscn")
var introText = "Enjoy Plitvice time!"
var winText = "You did it!"
var onScreenPopUpText = "Are you sure you want to leave the minigame?"
var onScreenYesText = "Yes"
var onScreenNoText = "No"
var onScreenGui
var activeBloop
	
func _ready():
	if !GlobalSound.get_node("BgSounds/Waterfall").is_playing():
		GlobalSound.get_node("BgSounds/Waterfall").play()
	setupVars()
	setupTimer()
	displayIntroPopup()
	addOnScreenGui()
	onScreenGuiVisible(false)

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
	timer.wait_time = 1.5
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)

func displayIntroPopup():
	var introPopUp = minigameIntroPopUp.instance()
	introPopUp.init(introText, "plitvice")
	introPopUp.connect("startMinigame", self, "startGame")
	add_child(introPopUp)

func addOnScreenGui():
	onScreenGui = minigameOnScreenGUI.instance()
	onScreenGui.init(onScreenPopUpText, onScreenYesText, onScreenNoText)
	onScreenGui.connect("restartMinigame", self, "restartGame")
	add_child(onScreenGui)

func onScreenGuiVisible(visible):
	onScreenGui.visible = visible

func startGame():
	onScreenGuiVisible(true)
	loadRequiredIngredients()
	timer.start()

func _on_timer_timeout():
	generateFallingIngredients()

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

func restartGame():
	onScreenGuiVisible(true)
	resetVars()
	setupVars()
	loadRequiredIngredients()
	timer.start()

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
		#if there are more than 1 left to collect make sure to not 
		#have multiple ing of same type falling
		if requiredIngrediendArray.size() > 1:
			for obj in allFallingNow:
				if obj.collectable:
					if str(obj.name) in str(object):
						object = requiredIngrediendArray[1]
		setBranchCounter()

	animateFallingObject(waterfallOptions[0], object)

func setBranchCounter():
	#var branchCounterOptions = [2,3,4]
	#FOR DEBUGGING
	var branchCounterOptions = [2]
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
	allFallingNow.push_back(fallingIngredient)
	#print("------------------------------------------")
	#print("falling ingredient: " + str(fallingIngredient))
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
#	print("ITEM FELL")
	if !fallingIngredient.collidedWithKuna:
		GlobalSound.get_node("Plitvice/Drip").play()
		activeBloop = waterfallOption.get_node("bloop")
		activeBloop.visible = true
		activeBloop.get_node("AnimationPlayerBloop").play("bloop")
	newPathFollow.queue_free()
	allFallingNow.erase(fallingIngredient)

func _on_kunaArea2D_area_entered(area):
	area.collidedWithKuna = true
	area.visible = false
	if requiredIngrediendArray.has(area.filename) && area.collectable:
		for ing in positionedRequiredIngredients:
			if ing.filename == area.filename:
				GlobalSound.get_node("Plitvice/CollectSoft").play()
				#print("removing ing: " + str(ing))
				#print("required ingredients before: ", requiredIngrediendArray)
				ing.get_child(0).visible = true
				var ingSceneName = "res://Scenes/Games/GamePlitvice/ingredients/"+ing.name+".tscn"
				requiredIngrediendArray.erase(ingSceneName)
				#print("required ingredients after: ", requiredIngrediendArray)
				if requiredIngrediendArray == []:
					for obj in allFallingNow:
						obj.collectable = false
					resetVars()
					onScreenGuiVisible(false)
					displayWinPopUp()
	else:
		GlobalSound.get_node("Plitvice/Boing").play()
		kunaAP.play("bonk")
		yield(kunaAP, "animation_finished")
		kunaAP.play("swim")

func resetVars():
	branches.clear()
	ingredientArray.clear()
	requiredIngrediendArray.clear()
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


func _on_AnimationPlayerBloop_animation_finished(anim_name):
	print("ANIMATION FINISHED")
	activeBloop.visible = false
	activeBloop = null
	

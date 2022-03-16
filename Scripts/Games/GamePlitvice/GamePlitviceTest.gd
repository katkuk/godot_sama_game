extends Node2D

onready var ingredientPositions = $requiredIngPositions
onready var waterfallOptionsGroup = $waterfallOptions
onready var currentPath = null
onready var ingredientArray2 = []
onready var requiredIngrediendArray = []
var positionedRequiredIngredients = []
onready var kunaAP = $Kuna/kuna/AnimationPlayer
onready var branches = ["res://Scenes/Games/GamePlitvice/branches/branch1.tscn","res://Scenes/Games/GamePlitvice/branches/branch2.tscn","res://Scenes/Games/GamePlitvice/branches/branch3.tscn","res://Scenes/Games/GamePlitvice/branches/branch4.tscn"]
onready var branchCounter = 3

func _process(delta):
	pass
	
func _ready():
	for n in range(1,11):
		var scene = "res://Scenes/Games/GamePlitvice/ingredients/ingredient"+str(n)+".tscn"
		ingredientArray2.push_front(scene)
	randomize()
	ingredientArray2.shuffle()
	requiredIngrediendArray = ingredientArray2.slice(0,4,1)
	getRequiredIngredients()
	generateFallingIngredients()

func getRequiredIngredients():
	var positions = ingredientPositions.get_children()
	var i = -1
	for position in positions:
		i = i+1
		var whereItBe = ingredientArray2[i];
		var Ingredient = load(whereItBe)
		var ingredient = Ingredient.instance()
		var main = get_tree().current_scene
		ingredient.scale = Vector2(0.4, 0.4)
		main.add_child(ingredient)
		positionedRequiredIngredients.push_front(ingredient)
		ingredient.global_position = position.global_position


func generateFallingIngredients():
	var waterfallOptions = waterfallOptionsGroup.get_children()
	var object = null
	requiredIngrediendArray.shuffle()
	randomize()
	waterfallOptions.shuffle()
	randomize()
	if branchCounter > 0:
		var whichBranch = [0,1,2,3]
		whichBranch.shuffle()
		randomize()
		object = branches[whichBranch[0]]
		branchCounter = branchCounter - 1
	else:
		object = requiredIngrediendArray[0]
		var howManyBranches = [2,3,4]
		randomize()
		howManyBranches.shuffle()
		print("new branch count:" + str(howManyBranches[0]))
		branchCounter = howManyBranches[0]
	
	animateFallingObject(waterfallOptions[0], object)
	
func animateFallingObject(waterfallOption, object):
	var newPathFollow = PathFollow2D.new()
	waterfallOption.add_child(newPathFollow)
	currentPath = newPathFollow
	var FallingIngredient = load(object)
	var fallingIngredient = FallingIngredient.instance()
	fallingIngredient.scale = Vector2(0.4, 0.4)
	currentPath.add_child(fallingIngredient)
	#createAnimationplayer and animation
	var animationPlayer = AnimationPlayer.new()
	var animation = Animation.new()
	currentPath.add_child(animationPlayer)
	animation.set_length(1)
	animation.add_track(0)
	var waterfallOptionName = waterfallOption.get_name()
	#print(newPathFollow.get_path())
	var newPathFollowName = str(newPathFollow.get_path())
	newPathFollowName = newPathFollowName.replace("/root/Node2D/waterfallOptions", "")
	#print(newPathFollowName)
	animation.track_set_path(0,"/root/Node2D/waterfallOptions"+newPathFollowName +"/:unit_offset")
	animation.track_insert_key(0,0.0,0.0)
	animation.track_insert_key(0,1.0,1.0)
	animationPlayer.add_animation("falling", animation)
	animationPlayer.set_speed_scale(0.2)
	animationPlayer.play("falling")
	#handleRemovingErrything
	yield(animationPlayer, "animation_finished")
	newPathFollow.queue_free()
	
func _on_Timer_timeout():
	generateFallingIngredients()
	pass

func _on_kunaArea2D_area_entered(area):
	if requiredIngrediendArray.has(area.filename):
		for ing in positionedRequiredIngredients:
			if ing.filename == area.filename:
				ing.get_child(0).visible = true
	else:
		print("NOP")
		kunaAP.play("bonk")
		yield(kunaAP, "animation_finished")
		kunaAP.play("swim")

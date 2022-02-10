extends Node2D

onready var ingredientPositions = $requiredIngPositions
onready var waterfallOptionsGroup = $waterfallOptions
onready var currentPath = null
onready var ingredientArray2 = []
onready var animPlayerIngredients = $ingredientsFallingAnimPlayer


func _process(delta):
	pass

func _ready():
	for n in range(1,11):
		var scene = "res://Games/GamePlitvice/ingredients/ingredient"+str(n)+".tscn"
		ingredientArray2.push_front(scene)
		
	randomize()
	ingredientArray2.shuffle()
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
		main.add_child(ingredient)
		ingredient.global_position = position.global_position

		
func generateFallingIngredients():
	var waterfallOptions = waterfallOptionsGroup.get_children()
	randomize()
	ingredientArray2.shuffle()
	randomize()
	waterfallOptions.shuffle()
	animateFallingIngredient(waterfallOptions[0], ingredientArray2[0])
	
func animateFallingIngredient(waterfallOption, ingredient):
	var newPathFollow = PathFollow2D.new()
	waterfallOption.add_child(newPathFollow)
	currentPath = newPathFollow
	var FallingIngredient = load(ingredient)
	var fallingIngredient = FallingIngredient.instance()
	currentPath.add_child(fallingIngredient)
	#print(newPathFollow)
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


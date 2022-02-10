extends Node2D

onready var ingredientPositions = $requiredIngPositions
onready var waterfallOptionsGroup = $waterfallOptions
onready var currentPath = null
onready var ingredientArray2 = []
onready var animPlayerIngredients = $ingredientsFallingAnimPlayer

#var t := 0.0

func _process(delta):
	#t += delta
	#$waterfallOptions/Path2D/PathFollow2D.offset = t * 200.0
	#currentPath.offset = t * 200.0
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
		#ingredientArray2[i].global_position = position.global_position
		var whereItBe = ingredientArray2[i];
		#print (whereItBe)
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
	print(waterfallOption)
	currentPath = waterfallOption.get_node("PathFollow2D")
	var FallingIngredient = load(ingredient)
	var fallingIngredient = FallingIngredient.instance()
	currentPath.add_child(fallingIngredient)
	#createAnimation
	var animation = Animation.new()
	animation.set_length(1)
	animation.add_track(0)
	var waterfallOptionName = waterfallOption.get_name()
	animation.track_set_path(0, "waterfallOptions/"+ waterfallOptionName +"/PathFollow2D:unit_offset")
	animation.track_insert_key(0,0.0,0.0)
	animation.track_insert_key(0,1.0,1.0)
	animPlayerIngredients.add_animation("falling", animation)
	animPlayerIngredients.set_speed_scale(0.2)
	animPlayerIngredients.play("falling")
	
	
	#currentPath.set_unit_offset(0)

	
func _on_Timer_timeout():
	generateFallingIngredients()
	pass

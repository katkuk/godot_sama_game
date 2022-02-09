extends Node2D


onready var ingredientPositions = $requiredIngPositions
onready var waterfallOptions = $waterfallOptions
onready var currentPath = null
onready var ingredientArray2 = []


var t := 0.0

func _process(delta):
	t += delta
	#$waterfallOptions/Path2D/PathFollow2D.offset = t * 200.0
	currentPath.offset = t * 200.0

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
	waterfallOptions = waterfallOptions.get_children()
	randomize()
	ingredientArray2.shuffle()
	waterfallOptions.shuffle()
	animateFallingIngredient(waterfallOptions[0], ingredientArray2[0])
	
func animateFallingIngredient(waterfallOption, ingredient):
	currentPath = waterfallOption.get_node("PathFollow2D")
	var FallingIngredient = load(ingredient)
	var fallingIngredient = FallingIngredient.instance()
	currentPath.add_child(fallingIngredient)
	currentPath.set_unit_offset(0)

	
	


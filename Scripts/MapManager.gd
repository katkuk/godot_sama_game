extends Node2D

var current_scene #used to store the scene which is being displayed, if no scene is displayed this should be null
var next_scene #used for storing next scene
var current_story #used for storing current story, when no story is playing this is null
var storyList = {
	"caroline" : { 1 : "res://Scenes/TestScenes/CarolineWindowSceneTest.tscn",
			2 : "res://Scenes/TestScenes/DragonTest2.tscn",
			3 : "res://Scenes/TestScenes/CarolineShipSceneTest.tscn"},
	"dragon": { 1 : "res://Scenes/TestScenes/DragonTest2.tscn",
			2 : "res://Scenes/TestScenes/CarolineShipSceneTest.tscn"},
	"kuna": {1 : "res://Scenes/KunaHouseScene.tscn"}
	}
onready var book = get_parent().get_node("Book1")
onready var bookAnimationPlayer = get_parent().get_node("Book1/BookAnimationPlayer")
onready var transitionShaderAP = get_parent().get_node("Book1/Node2D/TransitionShader/TransitionShaderAP")
onready var bookBackground = get_parent().get_node("Book1/BookBackground")
onready var bookGUI = get_parent().get_node("BookGUI")
onready var ScenePlaceholder = get_parent().get_node("Book1/ScenePlaceholder")

func _ready():
	bookGUI.visible = false;

func _on_MapIcon_pressed(story: String):
	print("story name is: " + story)
	print(current_scene)
	current_story = story
	animateBookIn(current_story)
	#displayBookGUI(true)
	#loadScene(story, 1, true)

func animateBookIn(story):
	bookAnimationPlayer.play("animateIn")
	yield(bookAnimationPlayer, "animation_finished")
	book.play("bookCoverOpen")
	yield(book, "animation_finished")
	displayBookGUI(true)
	loadScene(story, 1, true)

func loadScene(story : String, index : int, keepOldScene : bool):
	if keepOldScene == false:
		current_scene.queue_free()
		
	next_scene = load(storyList[story][index]).instance()
	#use this instead when the book is positioned properly
	#book.add_child(next_scene)
	transitionShaderAP.play("fadeIn")
	#yield(transitionShaderAP, "animation_finished")
	ScenePlaceholder.add_child(next_scene)
	#ScenePlaceholder.set_z_index(-4)
	#ScenePlaceholder.set_z_as_relative(true)
	next_scene.set_global_scale(Vector2(0.95, 0.91))
	next_scene.set_global_position(Vector2(70,35))
	#next_scene.set_global_position(Vector2(200,220))
	next_scene.rotate(deg2rad(1.5))
	current_scene = next_scene
	updateBookGUI()

func displayBookGUI(display : bool):
	bookGUI.visible = display

func updateBookGUI():
	for scene in storyList[current_story]:
		if current_scene.name in storyList[current_story][scene]:
			print(scene)
			if scene >= storyList[current_story].size():
				print("this is the last scene in the story")
				bookGUI.get_node("Container/NextSceneButton").visible = false;
				bookGUI.get_node("Container/PreviousSceneButton").visible = true;
			elif scene == 1:
				bookGUI.get_node("Container/NextSceneButton").visible = true;
				bookGUI.get_node("Container/PreviousSceneButton").visible = false;
			else:
				bookGUI.get_node("Container/NextSceneButton").visible = true;
				bookGUI.get_node("Container/PreviousSceneButton").visible = true;

func _on_CloseSceneButton_pressed():
	bookAnimationPlayer.play_backwards("animateIn")
	current_scene.queue_free()
	current_scene = null
	current_story = null
	displayBookGUI(false)

func _on_NextSceneButton_pressed():
	for scene in storyList[current_story]:
			if current_scene.name in storyList[current_story][scene]:
					var new_index = scene + 1
					loadScene(current_story, new_index, false)
					break

func _on_PreviousSceneButton_pressed():
	for scene in storyList[current_story]:
			if current_scene.name in storyList[current_story][scene]:
					var new_index = scene - 1
					loadScene(current_story, new_index, false)
					break
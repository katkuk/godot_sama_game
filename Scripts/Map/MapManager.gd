extends Node2D

var current_scene #used to store the scene which is being displayed, if no scene is displayed this should be null
var next_scene #used for storing next scene
var current_story #used for storing current story, when no story is playing this is null

#var storyList = {
#	"caroline" : { 1 : "res://Scenes/TestScenes/CarolineWindowSceneTest.tscn",
#			2 : "res://Scenes/TestScenes/DragonTest2.tscn",
#			3 : "res://Scenes/TestScenes/CarolineShipSceneTest.tscn"},
#	"dragon": { 1 : "res://Scenes/TestScenes/DragonTest2.tscn",
#			2 : "res://Scenes/TestScenes/CarolineShipSceneTest.tscn"},
#	"kuna": {1 : "res://Scenes/KunaHouseScene.tscn"}
#	}

var storyList = {
	"caroline" : { 1 : "res://Scenes/Stories/StoryCaroline/CarolineShipScene.tscn",
			2 : "res://Scenes/Stories/StoryCaroline/RijekaAttackedScene.tscn",
			3 : "res://Scenes/Stories/StoryCaroline/CarolineWindowScene.tscn",
			4: "res://Scenes/Stories/StoryCaroline/RijekaCircleScene.tscn",
			5: "res://Scenes/Stories/StoryCaroline/RijekaDiscussionScene.tscn",
			6: "res://Scenes/Stories/StoryCaroline/RijekaSavedScene.tscn",
			7: "res://Scenes/Stories/StoryCaroline/CarolineBookGameScreen.tscn"},
	"klek" : { 1 : "res://Scenes/Stories/StoryKlek/MagicStuff.tscn",
			2 : "res://Scenes/Stories/StoryKlek/KlekSittingOnHill.tscn",
			3 : "res://Scenes/Stories/StoryKlek/KlekAndVolos.tscn",
			4: "res://Scenes/Stories/StoryKlek/VolosInClouds.tscn",
			5: "res://Scenes/Stories/StoryKlek/KlekBecameMountain.tscn",
			6: "res://Scenes/Stories/StoryKlek/KlekBookGameScreen.tscn"}
	}

onready var book = get_parent().get_node("Book1")
onready var bookAnimationPlayer = get_parent().get_node("Book1/BookAnimationPlayer")
onready var transitionShaderAP = get_parent().get_node("Book1/Node2D/TransitionShader/TransitionShaderAP")
onready var bookBackground = get_parent().get_node("Book1/BookBackground")
onready var bookGUI = get_parent().get_node("BookGUI")
onready var scenePlaceholder = get_parent().get_node("Book1/ScenePlaceholder")

func _ready():
	bookGUI.visible = false;

func _on_MapIcon_pressed(story: String):
	#print("clicked on btn with story: " + story)
	current_story = story
	bookAnimationPlayer.play("animateIn")
	yield(bookAnimationPlayer, "animation_finished")
	bookAnimationPlayer.play("bookCoverOpen")
	yield(bookAnimationPlayer, "animation_finished")
	displayBookGUI(true)
	loadScene(story, 1, true)

func loadScene(story : String, index : int, keepOldScene : bool):
	if keepOldScene == false:
		scenePlaceholder.remove_child(current_scene)
		current_scene.queue_free()
	#print("loading scene: " + str(index) + ", from story: " + story)
	next_scene = load(storyList[story][index]).instance()
	transitionShaderAP.play("fadeIn")
	scenePlaceholder.add_child(next_scene)
	next_scene.set_global_scale(Vector2(0.95, 0.91))
	next_scene.set_global_position(Vector2(70,35))
	next_scene.rotate(deg2rad(1.5))
	current_scene = next_scene
	updateBookGUI()

func displayBookGUI(display : bool):
	bookGUI.visible = display

func updateBookGUI():
	var GUIcolor
	if "GUIColorHex" in current_scene:
		GUIcolor = current_scene.GUIColorHex
	else:
		GUIcolor = "#ffffff"
	#update colors
	bookGUI.get_node("Container/NextSceneButton").set_modulate(Color(GUIcolor))
	bookGUI.get_node("Container/PreviousSceneButton").set_modulate(Color(GUIcolor))
	bookGUI.get_node("Container/CloseSceneButton").set_modulate(Color(GUIcolor))
	
	#update visibility
	for scene in storyList[current_story]:
		if current_scene.name in storyList[current_story][scene]:
			if scene >= storyList[current_story].size():
				#print("this is the last scene in the story")
				bookGUI.get_node("Container/NextSceneButton").visible = false;
				bookGUI.get_node("Container/PreviousSceneButton").visible = true;
			elif scene == 1:
				#print("this is the first scene in the story")
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

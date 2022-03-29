extends Node2D

var current_scene #used to store the scene which is being displayed, if no scene is displayed this should be null
var next_scene #used for storing next scene
var current_story #used for storing current story, when no story is playing this is null
var storyList = {
	"caroline" : { 1 : "res://Scenes/Stories/StoryCaroline/CarolineShipScene.tscn",
			2 : "res://Scenes/Stories/StoryCaroline/RijekaAttackedScene.tscn",
			3 : "res://Scenes/Stories/StoryCaroline/CarolineWindowScene.tscn",
			4: "res://Scenes/Stories/StoryCaroline/RijekaCircleScene.tscn",
			5: "res://Scenes/Stories/StoryCaroline/RijekaDiscussionScene.tscn",
			6: "res://Scenes/Stories/StoryCaroline/RijekaSavedScene.tscn",
			7: "res://Scenes/Stories/PlayMinigameBookScreen.tscn"},
	"klek" : { 1 : "res://Scenes/Stories/StoryKlek/VolosInClouds.tscn",
			2 : "res://Scenes/Stories/StoryKlek/KlekSittingOnHill.tscn",
			3 : "res://Scenes/Stories/StoryKlek/KlekAndVolos.tscn",
			4: "res://Scenes/Stories/StoryKlek/MagicStuff.tscn",
			5: "res://Scenes/Stories/StoryKlek/KlekBecameMountain.tscn",
			6: "res://Scenes/Stories/PlayMinigameBookScreen.tscn"}
	}
onready var book = get_parent().get_node("Book1")
onready var bookAnimationPlayer = get_parent().get_node("Book1/BookAnimationPlayer")
onready var transitionShaderAP = get_parent().get_node("Book1/Node2D/TransitionShader/TransitionShaderAP")
onready var bookBackground = get_parent().get_node("Book1/BookBackground")
onready var bookGUI = get_parent().get_node("BookGUI")
onready var scenePlaceholder = get_parent().get_node("Book1/ScenePlaceholder")
onready var homeBtn = preload("res://Scenes/GUI/HomeBtn.tscn")
var homeBtnPopUpText = "Are you sure you want to go back to house?"
var homeBtnYesText = "Yes"
var homeBtnNoText = "No"
var homeBtnInstantiatedScene

func _ready():
	bookGUI.visible = false;
	displayHomeBtn()
	homeBtnVisibility(true)

func displayHomeBtn():
	homeBtnInstantiatedScene = homeBtn.instance()
	homeBtnInstantiatedScene.init(homeBtnPopUpText, homeBtnYesText, homeBtnNoText, "#a0403e", false)
	add_child(homeBtnInstantiatedScene)

func homeBtnVisibility(visible):
	homeBtnInstantiatedScene.visible = visible

func _on_MapIcon_pressed(story: String):
	#print("clicked on btn with story: " + story)
	homeBtnVisibility(false)
	current_story = story
	Global.updateStory(current_story)
	bookAnimationPlayer.play("animateIn")
	yield(bookAnimationPlayer, "animation_finished")
	bookAnimationPlayer.play("bookCoverOpen")
	yield(bookAnimationPlayer, "animation_finished")
	displayBookGUI(true)
	disableMapIcons(true)
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
	#print("current scene is " + str(current_scene))
	updateBookGUI()

func displayBookGUI(display : bool):
	bookGUI.visible = display

func disableMapIcons(disable):
	for btn in get_parent().get_node("MapIcons").get_children():
		if btn is TextureButton:
			#had to do visible because when disabled btns still consume input -.-
			btn.visible = !disable

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
			#print("this scene index: " + str(scene))
			#print("number of scenes in this story: " + str(storyList[current_story].size()))
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
	homeBtnVisibility(true)
	bookAnimationPlayer.play_backwards("animateIn")
	current_scene.queue_free()
	current_scene = null
	current_story = null
	disableMapIcons(false)
	displayBookGUI(false)
	Global.updateStory(current_story)

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

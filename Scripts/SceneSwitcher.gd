extends Node

onready var current_scene = $KunaHouseScene
onready var kuna = $KunaHouseScene/Control/Kuna
onready var book = $Book1
onready var bookAnimationPlayer = $Book1/BookAnimationPlayer
onready var transitionShaderAP = $Book1/TransitionShader/TransitionShaderAP
onready var bookBackground = $Book1/BookBackground
var current_story
var next_scene
var storyList = {
	"Caroline" : { 1 : "res://Scenes/TestScenes/CarolineWindowSceneTest.tscn",
			2 : "res://Scenes/TestScenes/CarolineShipSceneTest.tscn"},
	"Other": { 1 : "res://Scenes/TestScenes/DragonTest2.tscn",
			2 : "res://Scenes/TestScenes/CarolineShipSceneTest.tscn"},
	"Kuna": {1 : "res://Scenes/KunaHouseScene.tscn"}
	}


func _ready() -> void:
	current_scene.connect("scene_changed", self, "handle_scene_changed")
	
func handle_scene_changed(current_scene_name: String, story_name: String):
	print("Got signal, current scene " + current_scene.name)
	print("Got signal, story " + story_name)
	current_story = story_name
	
	if current_scene.name == "KunaHouseScene":
		print("loading first scene from " + story_name)
		#load the first scene in the new story
		switchScene(current_story, 1, true)
		#kuna stops taking input and idling
		kuna.kunaSceneIsActive = false
	
	elif story_name == "Home":
		#if the clicked btn has value home, go to Kuna house scene
		goToHomeScene()

	elif current_scene.name != "KunaHouseScene" && story_name != "Home":
		#if this is the last scene in this story go back to Kuna
		#else load next scene in the story
		for scene in storyList[current_story]:
			print(storyList[current_story][scene])
			if current_scene.name in storyList[current_story][scene]:
				if scene >= storyList[current_story].size():
					print("this is the last scene in the story, return to Kuna")
					goToHomeScene()
					break
				else:
					var new_index = scene + 1
					print("index is: ", str(new_index))
					switchScene(current_story, new_index, false)
					break
	
#use with true if you want to keep the kuna scene and load on top
#use with false when switching between scenes in a story
func switchScene(current_story : String, index : int, keepOldScene : bool):
	if keepOldScene == true:
		bookAnimationPlayer.play("animateIn")
		yield(get_node("Book1/BookAnimationPlayer"), "animation_finished")
		book.play("bookCoverOpen")
		yield(book, "animation_finished")
		print("loading this: " + storyList[current_story][index])
		next_scene = load(storyList[current_story][index]).instance()
		transitionShaderAP.play("fadeIn")
		add_child(next_scene)
		next_scene.connect("scene_changed", self, "handle_scene_changed")
	elif keepOldScene == false:
		current_scene.queue_free()
		book.play("bookFlip")
		yield(book, "animation_finished")
		next_scene = load(storyList[current_story][index]).instance()
		transitionShaderAP.play("fadeIn")
		add_child(next_scene)
		next_scene.connect("scene_changed", self, "handle_scene_changed")

	current_scene = next_scene
	current_scene.set_global_scale(Vector2(0.95, 0.91))
	current_scene.set_global_position(Vector2(355,35))
	current_scene.rotate(deg2rad(1.5))

#kills current scene and goes to Kuna
func goToHomeScene():
	bookAnimationPlayer.play_backwards("animateIn")
	current_scene.queue_free()
	current_scene = $KunaHouseScene
	#kuna takes input and can idle again
	kuna.kunaSceneIsActive = true


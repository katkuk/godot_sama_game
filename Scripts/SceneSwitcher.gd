extends Node

onready var current_scene = $KunaHouseScene
onready var kuna = $KunaHouseScene/Control/Kuna
onready var book = $Book1
onready var bookAnimationPlayer = $Book1/BookAnimationPlayer
var current_story
var next_scene
var storyList = {
	"Caroline" : { 1 : "res://TestScenes/CarolineWindowSceneTest.tscn",
			2 : "res://TestScenes/CarolineShipSceneTest.tscn"},
	"Other": { 1 : "res://TestScenes/DragonTest2.tscn",
			2 : "res://TestScenes/CarolineShipSceneTest.tscn"},
	"Kuna": {1 : "res://KunaHouseScene.tscn"}
	}


func _ready() -> void:
	current_scene.connect("scene_changed", self, "handle_scene_changed")
	
func handle_scene_changed(current_scene_name: String, story_name: String):
	print("Got signal, current scene " + current_scene.name)
	print("Got signal, story " + story_name)
	current_story = story_name
	
	if current_scene.name == "KunaHouseScene":
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
		next_scene = load(storyList[current_story][index]).instance()
		add_child(next_scene)
		next_scene.connect("scene_changed", self, "handle_scene_changed")
	elif keepOldScene == false:
		current_scene.queue_free()
		book.play("bookFlip")
		yield(book, "animation_finished")
		next_scene = load(storyList[current_story][index]).instance()
		add_child(next_scene)
		next_scene.connect("scene_changed", self, "handle_scene_changed")

	current_scene = next_scene
	current_scene.set_global_scale(Vector2(0.83, 0.83))
	current_scene.set_global_position(Vector2(140,150))

#kills current scene and goes to Kuna
func goToHomeScene():
	bookAnimationPlayer.play("animateOut")
	current_scene.queue_free()
	current_scene = $KunaHouseScene
	#kuna takes input and can idle again
	kuna.kunaSceneIsActive = true


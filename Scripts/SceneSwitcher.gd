extends Node

onready var current_scene = $KunaHouseScene
var current_story
var next_scene
var storyList = {
	"Caroline" : { 1 : "res://StoryCaroline/CarolineWindowScene.tscn",
			2 : "res://StoryCaroline/CarolineShipScene.tscn"},
	"Other": { 1 : "res://StoryDragonsEye/Dragon2.tscn"},
	"Kuna": {1 : "res://KunaHouseScene.tscn"}
	}

func _ready() -> void:
	current_scene.connect("scene_changed", self, "handle_scene_changed")
	
	
func handle_scene_changed(current_scene_name: String, story_name: String):
	print("Got signal, current scene " + current_scene_name)
	print("Got signal, story " + story_name)
	current_story = story_name
	
	if current_scene.name == "KunaHouseScene":
		#load the first scene in the new story
		print(storyList[current_story][1])
		switchScene(current_story, 1)
	elif current_scene.name != "KunaHouseScene" && story_name != "Home":
		#if this is the last scene in this story go back to Kuna
		#else load next scene in the story
		print("we are not in kuna house")
		print(current_scene.name)
		print("number of scenes in the story " , storyList[current_story])
		print("size " , storyList[current_story].size())
		for scene in storyList[current_story]:
			if current_scene.name in storyList[current_story][scene]:
				if scene >= storyList[current_story].size():
					print("this is the last scene in the story, return to Kuna")
					#switchScene("Kuna", 1)
				else:
					var new_index = scene + 1
					print(new_index)
					print(storyList[current_story][new_index])
					switchScene(current_story, new_index)
			break
	elif story_name == "Home":
		switchScene("Kuna", 1)

func switchScene(current_story : String, index : int):
	next_scene = load(storyList[current_story][index]).instance()
	add_child(next_scene)
	next_scene.connect("scene_changed", self, "handle_scene_changed")
	current_scene.queue_free()
	current_scene = next_scene

#onready var current_level = $RijekaAttackedScene

#func _ready():
	#current_level.connect("level_changed", self, "handle_level_changed")
	
#func handle_level_changed(current_level_name):
	#print("buttonClicked")
	#var next_level
	#var next_level_name
		
	#some logic to decide what is the next level
	#something like find current level 
	#in the list and give me the next one after that
	#var sceneList = {
		#"kunaHouse": true,
		#"settings" : true,
		#"caroline" : { 1 : "CarolineShipScene",
			#2 : "RijekaAttackedScene",
			#3 : "CarolineWindowScene",
			#4 : "RijekaCircleScene",
			#5 : "RijekaDiscussionScene",
			#6 : "RijekaSavedScene"},
		#"carolineGame": true
	#}
	
	#privremeno. kad se vrati treba bit next_level_name ono sto je odluceno u logici gore
	#next_level_name = current_level_name
	
	#if current_level_name == "RijekaAttackedScene":
		#next_level_name = "CarolineWindowScene"
	#else:
		#next_level_name = "RijekaAttackedScene"
	
	#next_level = load("res://" + next_level_name + ".tscn").instance()
	#add_child(next_level)
	#next_level.connect("level_changed", self, "handle_level_changed")
	#current_level.queue_free()
	#current_level = next_level

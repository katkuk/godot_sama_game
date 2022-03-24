extends Node
var current_scene
var current_story

var sceneList = {
	"kuna" : "res://Scenes/KunaHouse/KunaHouseSceneTestKatka.tscn",
	"map" : "res://Scenes/Map/Map.tscn",
	"klek" : "res://Scenes/Games/GameKlek/Klek_MemoryGame.tscn",
	"caroline" : "res://Scenes/Games/GameCaroline/GameCaroline.tscn",
	"plitvice" : "res://Scenes/Games/GamePlitvice/GamePlitvice.tscn"
	}

func _ready():
	#print(get_tree().current_scene. get_child(0))
	current_scene = get_tree().current_scene.get_child(0)

func loadScene(newScene : String):
	current_scene.queue_free()
	var nextScene = load(sceneList[newScene]).instance()
	add_child(nextScene)
	current_scene = nextScene
	#print("new current scene is: " , current_scene)

func updateStory(story):
	current_story = story
	#print("global current story is: " + str(current_story))

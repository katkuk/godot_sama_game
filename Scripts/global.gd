extends Node
var current_scene
var current_story
const kuna = preload("res://Scripts/KunaHouse/Kuna_newMove.gd")

var sceneList = {
	"kuna" : "res://Scenes/KunaHouse/KunaHouseSceneTestKatka.tscn",
	"map" : "res://Scenes/Map/Map.tscn",
	"klek" : "res://Scenes/Games/GameKlek/Klek_MemoryGame.tscn",
	"caroline" : "res://Scenes/Games/GameCaroline/GameCaroline.tscn",
	"plitvice" : "res://Scenes/Games/GamePlitvice/GamePlitvice.tscn"
	}

var kunaSceneState = {
	"kunaPos" : 1554,
	"cameraPos" : 1112,
	"kunaInteractingWith" : "",
	"kunaState" : kuna.State.UNSELECTED,
	"gramophone" : false,
	"hangingLights" : true,
	"bigLampAleks" : false,
	"smallBedSideLamp" : false
}

func _ready():
	current_scene = get_tree().current_scene.get_child(0)
	#print(current_scene)

func loadScene(newScene : String):
	if current_scene.name == "KunaHouseScene":
		saveKunaScene()
	current_scene.queue_free()
	#GlobalSound.stopAllSounds()
	var nextScene = load(sceneList[newScene]).instance()
	add_child(nextScene)
	current_scene = nextScene
	#print("new current scene is: " , current_scene)

func updateStory(story):
	current_story = story
	#print("global current story is: " + str(current_story))

func saveKunaScene():
	current_scene.get_node("KunaHouseManager").saveScene()

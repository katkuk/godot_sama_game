extends TextureButton
class_name PlayMinigameBtn
var linkToScene

func _ready():
	pass

#constructor
func init(var l):
	linkToScene = l

func _pressed():
	#print("links to this scene: " + str(linkToScene) )
	GlobalSound.stopAllBackgroundSounds()
	Global.loadScene(linkToScene)

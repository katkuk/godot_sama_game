extends Node2D

func _ready():
	pass

func playSound(soundNode : String):
	get_node(soundNode).play()
	
func stopSound(soundNode : String):
	get_node(soundNode).stop()

func stopAllSounds():
	var soundsArray = self.get_children()
	for sound in soundsArray:
		sound.stop()

extends Node2D

func _ready():
	pass

func playSound(soundNode : String):
	get_node(soundNode).play()
	
func stopSound(soundNode : String):
	get_node(soundNode).stop()

func stopAllBackgroundSounds():
	for sound in get_node("BgSounds").get_children():
		if sound.is_playing():
			sound.stop()

#hmmm this one below doesn't work so I made a hack solution for now
#func stopAllSounds():
#	var soundsArray = self.get_children()
#	for sound in soundsArray:
#		sound.stop()


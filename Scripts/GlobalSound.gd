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
	
	for cardSound in get_node("Klek/Cards").get_children():
		if cardSound.is_playing():
			cardSound.stop()

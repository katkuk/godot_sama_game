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
	stopAllCardSounds()

func stopAllCardSounds():
	for cardSound in get_node("Klek/Cards").get_children():
		if cardSound.is_playing():
			cardSound.stop()

func stopAllStorySounds(_story : String):
	var story = _story[0].to_upper() + _story.substr(1, -1)
	#print(story)
	for sound in get_node(story).get_children():
		if sound.is_playing():
			sound.stop()

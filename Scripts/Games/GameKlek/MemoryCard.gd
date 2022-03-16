extends TextureButton

class_name MemoryCard
onready var MemoryGameManager = get_tree().get_root().get_node("MemoryGame/Game")

#suit is int value 1-5, reffers to the image e.g. cloud, witch etc
var suit
#value is 1-2, because we need 2 identical cards from each suit
var value
var faceTexture
var backTexture
var matched

#constructor
func _init(var s, var v):
	suit = s
	value = v
	matched = false
	faceTexture = load("res://Assets/Textures/KlekStory/MemoryCardFace_"+str(suit)+".png")
	backTexture = preload("res://Assets/Textures/KlekStory/MemoryCardBackTexture.png")
	set_normal_texture(backTexture)

func _ready():
	set_h_size_flags(3)
	set_v_size_flags(3)
	set_expand(true)
	set_stretch_mode(TextureButton.STRETCH_KEEP_ASPECT_CENTERED)

func _pressed():
	MemoryGameManager.chooseCard(self)

func flip():
	if get_normal_texture() == backTexture:
		set_normal_texture(faceTexture)
	else:
		set_normal_texture(backTexture)



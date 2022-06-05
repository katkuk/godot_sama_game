extends Camera2D
onready var cameraTween = get_node("ShiftTween")
onready var kuna = get_parent().get_node("House/Kuna")
const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 0.9
var scrollRight = false
var scrollLeft = false

func _ready():
	kuna.connect("scroll", self, "scroll")

func _physics_process(delta):
	if scrollRight and position.x < 7177:
		position.x = lerp(position.x, position.x + 50, 25 * delta)
	elif scrollLeft and position.x > 1112:
		position.x = lerp(position.x, position.x - 50, 25 * delta)

func scroll(direction):
	if direction == "right":
		scrollRight = true
	elif direction == "left":
		scrollLeft = true
	elif direction == "stop":
		scrollRight = false
		scrollLeft = false

func _on_HouseArrow_button_down(direction):
	GlobalSound.get_node("UI/ButtonClick").play()
	if direction == "right":
		scrollRight = true
	elif direction == "left":
		scrollLeft = true

func _on_HouseArrow_button_up():
	scrollRight = false
	scrollLeft = false


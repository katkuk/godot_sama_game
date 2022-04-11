extends ColorRect

onready var volosRunningAP = get_parent().get_node("Volos/VolosRunning/Running")
onready var volosRunning = get_parent().get_node("Volos/VolosRunning")
onready var volosAngryAP = get_parent().get_node("Volos/VolosAngry/Angry")
onready var volosAngry = get_parent().get_node("Volos/VolosAngry")

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(1.5), "timeout")
	volosRunningAP.play("running")
	yield(volosRunningAP, "animation_finished")
	volosRunning.visible = false
	volosAngry.visible = true
	volosAngryAP.play("angry")
	



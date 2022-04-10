extends ColorRect

var selected = false
onready var selectedObject = get_parent().get_node("empty")
onready var initialWinePosition = Vector2(811.022, 919.193)

func _ready():
	selectedObject.z_index = 30

func _process(delta):
	if selected:
		followMouse()
	else:
		if selectedObject == get_parent().get_node("Wine/wine"):
			selectedObject = get_parent().get_node("empty")
			get_parent().get_node("Wine/wine").position = initialWinePosition
			get_parent().get_node("Wine/AnimationPlayer").play_backwards("wineAnim")
		else:
			selectedObject.visible = false;
			selectedObject = get_parent().get_node("empty")
		

func followMouse():
	selectedObject.visible = true;
	selectedObject.position = get_global_mouse_position()
	
func _on_clickFoodArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			selected = true
		else:
			selected = false	

func _on_Apples_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			selectedObject = get_parent().get_node("Apples/appleA")
			selectedObject.scale = Vector2(1,1)

func _on_Potatoes_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			selectedObject = get_parent().get_node("Potatoes/potatoA")
			selectedObject.scale = Vector2(1,1)

func _on_Grapes_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			selectedObject = get_parent().get_node("Grapes/grapesA")
			selectedObject.scale = Vector2(1,1)
			
func _on_Cookies_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			selectedObject = get_parent().get_node("Cookies/cookieA")
			selectedObject.scale = Vector2(1,1)
			
func _on_Cake_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			selectedObject = get_parent().get_node("Cake/cakeA")
			selectedObject.scale = Vector2(1,1)

func _on_Chicken_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			selectedObject = get_parent().get_node("Chicken/chickenA")
			selectedObject.scale = Vector2(1,1)

func _on_Wine_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			selectedObject = get_parent().get_node("Wine/wine")
			get_parent().get_node("Wine/AnimationPlayer").play("wineAnim")
			
func _on_Mouth_area_entered(area):
	if area.name == "cakeA" or \
	area.name == "appleA" or\
	area.name == "grapesA" or\
	area.name == "cookieA" or\
	area.name == "potatoA" or\
	area.name == "chickenA":
		area.scale = Vector2(0,0)
		get_parent().get_node("volos/eating").play("eating")
		yield(get_tree().create_timer(0.5), "timeout")
		get_parent().get_node("volos/eating").stop()


func _on_WineArea_area_entered(area):
	#if area.name == "Wine":
	#print(area.name)
		#get_parent().get_node("Wine/pour").play("pour")
	pass

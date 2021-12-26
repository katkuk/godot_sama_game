extends Node

#onready var current_level = $RijekaAttackedScene

#func _ready():
	#current_level.connect("level_changed", self, "handle_level_changed")
	
#func handle_level_changed(current_level_name):
	#print("buttonClicked")
	#var next_level
	#var next_level_name
		
	#some logic to decide what is the next level
	#something like find current level 
	#in the list and give me the next one after that
	#var sceneList = {
		#"kunaHouse": true,
		#"settings" : true,
		#"caroline" : { 1 : "CarolineShipScene",
			#2 : "RijekaAttackedScene",
			#3 : "CarolineWindowScene",
			#4 : "RijekaCircleScene",
			#5 : "RijekaDiscussionScene",
			#6 : "RijekaSavedScene"},
		#"carolineGame": true
	#}
	
	#privremeno. kad se vrati treba bit next_level_name ono sto je odluceno u logici gore
	#next_level_name = current_level_name
	
	#if current_level_name == "RijekaAttackedScene":
		#next_level_name = "CarolineWindowScene"
	#else:
		#next_level_name = "RijekaAttackedScene"
	
	#next_level = load("res://" + next_level_name + ".tscn").instance()
	#add_child(next_level)
	#next_level.connect("level_changed", self, "handle_level_changed")
	#current_level.queue_free()
	#current_level = next_level

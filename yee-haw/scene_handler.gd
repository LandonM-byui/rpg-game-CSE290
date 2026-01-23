extends Node

#assigning variables to make acessing the main scenes easier!
# -- As new main scenes get added, please add them up here as well!
# # # MAY be redundant depending on how scenes are loaded! Setting these up just in case
@onready var combat = get_node('Combat')
@onready var ui = get_node('UI')
@onready var main_menu = get_node('MainMenu')


 

# Possibly redundant, but here is a simple way to instantiate a scene!
#(Very basic exanple of creating an instance based on the Godot "2d rpg demo")
func _ready():
	combat.queue_free()
	var scene_menu = load("res://Scenes/main_menu.tscn")
	var menu_instance = scene_menu.instantiate()
	add_child(menu_instance)


# Trying to connect to the button press signal (main menu)
#func menu_buttons():
	#var menu_button = get_node('menu_instance/VBoxContainer/TextureButton')
	#menu_button.connect(button_down)
	

# a dev tool function to move to the combat screen for now
# DOES NOT WORK, should press 'N' to move scenes, needs troubleshooting
# -- should close the scene like in the _ready() function, 
# --   but isn't working for some reason?
func test_load_combat():
	if Input.is_action_pressed('Next_Scene'):
		main_menu.queue_free()
		#menu_instance.queue_free()
		var combat = load("res://Scenes/combat.tscn")
		var combat_instance = combat.instantiate()
		add_child(combat_instance)

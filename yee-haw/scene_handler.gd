extends Node2D

#assigning variables to make acessing the main scenes easier!
# -- As new main scenes get added, please add them up here as well!
@export var combat : PackedScene
@export var ui : PackedScene
@export var main_menu : PackedScene
@export var intro : PackedScene




# May need to be expanded for each button?
## use list/enums to loop through each one?
var _active_button : TextureButton
var _active_button_1 : TextureButton


var _current_scene : ScenePreset

## saw Dallin do this, don't understand it as well as I'd like, but giving this a try!
#var _callable : Callable



func _ready():
# setting main menu as initial scene, we can add other things later if we want!
	_remove_active_scene()
	_current_scene = main_menu.instantiate() #as ScenePreset
	add_child(_current_scene)
	return


# copied from Dallin. Thanks Dallin!!
func _remove_active_scene():
	if not _current_scene:
		return
	
	_current_scene.queue_free()


func _scene_from_main_menu():
	# will need to make sure that the correct button number is used as the intended button to change scenes
	_active_button = _current_scene.button
	var combat_scene = scene_loader(_current_scene, combat)
	_active_button.pressed.connect(combat_scene)
	




func scene_loader(current_scene,new_scene):
# Purpose: If new_scene is different than the current scene, clear old scene,
#  instantiate old scene
## current_scene: the variable named current_scene
## new_scene: the name of the scene that is to be swapped to
	if current_scene == new_scene:
		print('same as current scene')
		return
	else:
		current_scene.queue_free()
		print('freeing queue')
		#current_scene.clear()
		current_scene = new_scene.instantiate() as ScenePreset
		print('intantiating')
		add_child(current_scene)
		print('adding as child')
	return

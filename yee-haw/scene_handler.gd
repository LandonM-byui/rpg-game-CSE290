extends Node2D

#One last test change


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
	# as _current_scene is not currently a PackedScene but a class, 
	# - the scene loading function will not work until some scene is active.
	_current_scene = main_menu.instantiate() as ScenePreset
	add_child(_current_scene)
	_active_button = _current_scene.button
	# should load intro first, but the logic is different as intro doesn't have nay buttons
	_active_button.pressed.connect(_load_combat)
	
	
	#_current_scene = _load_combat()


# copied from Dallin. Thanks Dallin!!
func _remove_active_scene():
	if not _current_scene:
		return
	
	_current_scene.queue_free()


func _load_main_menu():
	# will need to make sure that the correct button number is used as the intended button to change scenes
	_current_scene = scene_loader(_current_scene, main_menu)
	_active_button = _current_scene.button
	return _active_button


func _load_intro():
	# not using the scene loader as the into may not have buttons
	## if we add a continue button to the scene loader, use the scene_loader function here!
	_current_scene.queue_free()
	_current_scene = intro.instantiate() as ScenePreset
	add_child(_current_scene)
	# will add timer to auto continue later!
	print('loaded intro')
	return _current_scene
	
	
	
func _load_combat(): # may overlay/also load UI, and put all buttons there?
	_current_scene = scene_loader(_current_scene, combat)
	_active_button = _current_scene.button
	print('loaded combat screen!')
	## add where we want to navigate next here!
	#_active_button.pressed.connect(load_"next scene")



func scene_loader(current_scene,new_scene):
# Purpose: If new_scene is different than the current scene, clear old scene,
#  instantiate old scene
## current_scene: the variable named current_scene
## new_scene: the name of the scene that is to be swapped to
	if current_scene == new_scene:
		print('same as current scene')
		return
	else:
		_remove_active_scene()
		print('freeing queue')
		#current_scene.clear()
		current_scene = new_scene.instantiate() as ScenePreset
		print('intantiating')
		add_child(current_scene)
		print('adding as child')
	return current_scene

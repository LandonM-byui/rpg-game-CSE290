extends Node2D

class_name SceneHandler

#assigning variables to make acessing the main scenes easier!
# -- As new main scenes get added, please add them up here as well!
@onready var combat : PackedScene = preload('uid://dhaa2ss681rt8')
@onready var ui : PackedScene = preload('uid://cui3llufng60e')
@onready var main_menu : PackedScene = preload('uid://c228h2u05ni0v')
@onready var intro : PackedScene = preload('uid://cbvxlnp0s3hm0')
@onready var upgrades : PackedScene = preload('uid://dak834hyky2oi')
@onready var combat_menu : PackedScene # PASTE UID in preload after merging = preload('')

#@export var 


enum MainScenes{
	MainMenu,
	Intro,
	Combat,
	Upgrades,
	CombatMenu
}



# May need to be expanded for each button?
## use list/enums to loop through each one?
var _active_button : SceneButton


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
	# should load intro first, but the logic is different as intro doesn't have nay buttons
	connect_buttons()
	
	
	#_current_scene = _load_combat()


# copied from Dallin. Thanks Dallin!!
func _remove_active_scene():
	if not _current_scene:
		return
	
	_current_scene.queue_free()


func disconnect_buttons():
		## disconnect each scene to each scene button 
	for button in _current_scene.scene_buttons:
		if button.scene == MainScenes.MainMenu:
			# main menu currently leads you to the combat screen!
			button.pressed.disconnect(_load_combat)
			print('main menu button connected')
			
		if button.scene == MainScenes.Intro:
			# currently blank, not even a button
			button.pressed.disconnect(_load_intro)
			print('intro button connected')
			
		if button.scene == MainScenes.Combat:
			# combat screen takes you to upgrades screen!
			button.pressed.disconnect(_load_upgrades)
			print('combat button connected')
			
		if button.scene == MainScenes.Upgrades:
			# as of now, upgrades screen leads you to the combat screen again!
			button.pressed.disconnect(_load_combat)
			print('upgrades button connected')
			
		if button.scene == MainScenes.CombatMenu:
			button.pressed.disconnect(_load_combat_menu)
			print('combat menu button connected')
		print('tried to connect buttons')
		pass


func connect_buttons():
		## connect each scene to each scene button 
	for button in _current_scene.scene_buttons:
		if button.scene == MainScenes.MainMenu:
			# main menu currently leads you to the combat screen!
			button.pressed.connect(_load_combat)
			print('main menu button connected')
			
		if button.scene == MainScenes.Intro:
			# currently blank, not even a button
			button.pressed.connect(_load_intro)
			print('intro button connected')
			
		if button.scene == MainScenes.Combat:
			# combat screen takes you to upgrades screen!
			button.pressed.connect(_load_upgrades)
			print('combat button connected')
			
		if button.scene == MainScenes.Upgrades:
			# as of now, upgrades screen leads you to the combat screen again!
			button.pressed.connect(_load_combat)
			print('upgrades button connected')
			
		if button.scene == MainScenes.CombatMenu:
			button.pressed.connect(_load_combat_menu)
			print('combat menu button connected')
		else:
			print('tried to connect buttons')
		pass


func _load_main_menu():
	# will need to make sure that the correct button number is used as the intended button to change scenes
	_current_scene = scene_loader(_current_scene, main_menu)
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
	print('loaded combat screen!')
	## add where we want to navigate next here!
	# to upgrades screen next!


func _load_upgrades():
	_current_scene = scene_loader(_current_scene, upgrades)
	print('Loaded upgrades Screen!')

func _load_combat_menu():
	pass


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
		disconnect_buttons()
		print('disconnecting scene buttons')
		#current_scene.clear()
		current_scene = new_scene.instantiate() as ScenePreset
		print('intantiating')
		connect_buttons()
		print('Connecting Buttons')
		add_child(current_scene)
		print('adding as child')
	return current_scene

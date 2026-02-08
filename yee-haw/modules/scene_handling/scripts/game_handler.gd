extends Node

## Top-level game handler that load and unloads scenes, and passes data between them.
## Only one full scene is loaded at a time. All submenus are constantly loaded but hidden in the 
## project heirarchy. When submenus are enabled, is simply unhides them.
class_name GameHandler

## Main scene .tscn
@onready var main_scene_prefab : PackedScene = preload("uid://cq2eimbn0rhn4")
## Deck choice scene .tscn
@onready var deck_scene_prefab : PackedScene = preload("uid://dg1a80yhp3ovf")
## Game scene .tscn
@onready var game_scene_prefab : PackedScene = preload("uid://6yy4qsd2i3qx")

## Root node to attach created scenes to
@export var scene_root : Node
## Root node to attach all submenus to
@export var submenu_root : Control
## Full root for all submenues (including darkbox)
@export var full_subscene_root : Control

## Settings scene .tscn
@onready var settings_subscene_prefab : PackedScene = preload("uid://vo1hnxymycx7")
## Built settings scene
var _settings : SubmenuHandler

## Game menu scene .tscn
@onready var game_menu_subscene_prefab : PackedScene = preload("uid://bl75eggnjadl7")
## Built game menu scene
var _game_menu : SubmenuHandler

## Currently loaded full scene
var _loaded_scene : SceneController
## The reference scene type of the currently loaded scene
var _loaded_scene_ref : FullSceneButton.GameSceneReference

## Persistant data through project runtime
var _project_data : ProjectData

func _ready() -> void:
	# initialize project data
	_project_data = ProjectData.new()
	
	# hide submenus
	full_subscene_root.visible = false
	
	# create submenus
	_build_settings_submenu()
	_build_game_menu_subscene()
	
	# load the main scene
	_load_scene(FullSceneButton.GameSceneReference.MainMenu)

## Loads a full scene and connects its signals
func _load_scene(ref: FullSceneButton.GameSceneReference) -> void:
	# if the loaded scene is already [param ref], nothing changes
	if _loaded_scene != null and ref == _loaded_scene_ref: return
	
	# unload the current scene
	_unload_current_scene()
	
	# create the new scene type
	match ref:
		FullSceneButton.GameSceneReference.MainMenu: 
			_loaded_scene = main_scene_prefab.instantiate()
		FullSceneButton.GameSceneReference.DeckChoice:
			_loaded_scene = deck_scene_prefab.instantiate()
		FullSceneButton.GameSceneReference.Game:
			_loaded_scene = game_scene_prefab.instantiate()
	
	# connect scene signals
	_connect_prop_signals()
	_loaded_scene_ref = ref
	
	# node parenting
	scene_root.add_child(_loaded_scene)
	
	# hide subscenes when switching scenes
	_settings.visible = false
	_game_menu.visible = false
	full_subscene_root.visible = false

## Unloads and disconnects signals from the current loaded scene
func _unload_current_scene() -> void:
	# if no scene is loaded nothing needs to happen
	if _loaded_scene == null: return
	
	# disconnect all signals from current scene
	_loaded_scene.switch_scene.disconnect(_load_scene)
	_loaded_scene.open_subscene.disconnect(_open_subscene)
	_loaded_scene.quit_game.disconnect(_quit_game)
	
	# extract project data from the current scene, if any
	_loaded_scene.unload_scene(_project_data)
	
	# destroy the current scene
	_loaded_scene.queue_free()
	
## Connects all propogation signals from the current scene
func _connect_prop_signals() -> void:
	# only connects signals if there is a loaded scene
	if _loaded_scene == null: return
	
	_loaded_scene.switch_scene.connect(_load_scene)
	_loaded_scene.open_subscene.connect(_open_subscene)
	_loaded_scene.quit_game.connect(_quit_game)

## Opens a subscene/submenu within the current scene
func _open_subscene(ref: SubSceneButton.SubSceneReference) -> void:
	if ref == SubSceneButton.SubSceneReference.Settings:
		_settings.visible = true
		full_subscene_root.visible = true
		_settings.move_to_front()
		return
	
	if ref == SubSceneButton.SubSceneReference.GameMenu:
		print("Showing Game Menu")
		_game_menu.visible = true
		full_subscene_root.visible = true
		_game_menu.move_to_front()
		return

## Forces the game to stop
func _quit_game() -> void:
	get_tree().quit()

## Initializes setting up the settings submenu
func _build_settings_submenu() -> void:
	_settings = settings_subscene_prefab.instantiate()
	_settings.close_menu.connect(_close_settings)
	submenu_root.add_child(_settings)
	_settings.visible = false
	
	for button in _settings.scene_buttons:
		button.switch_scene.connect(_load_scene)
	for button in _settings.subscene_buttons:
		button.open_subscene.connect(_open_subscene)

## Closes the settings submenu
func _close_settings() -> void:
	_settings.visible = false
	_update_darkening_panel()

## Initialized the game menu submenu
func _build_game_menu_subscene() -> void:
	_game_menu = game_menu_subscene_prefab.instantiate()
	_game_menu.close_menu.connect(_close_game_menu)
	submenu_root.add_child(_game_menu)
	_game_menu.visible = false
	
	for button in _game_menu.scene_buttons:
		button.switch_scene.connect(_load_scene)
	for button in _game_menu.subscene_buttons:
		button.open_subscene.connect(_open_subscene)

## Closes the game menu
func _close_game_menu() -> void:
	_game_menu.visible = false
	_update_darkening_panel()

## Hides the darkening panel if no submenus are active/visible
func _update_darkening_panel() -> void:
	if _settings.visible:
		full_subscene_root.visible = true
		return
	
	full_subscene_root.visible = false

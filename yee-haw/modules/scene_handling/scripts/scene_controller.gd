extends Node

## Controls a project scene that can be referenced by the [GameHandler].
class_name SceneController

## All buttons that load new scenes
@export var scene_buttons : Array[FullSceneButton]
## All buttons that open submenus
@export var subscene_buttons : Array[SubSceneButton]
## All buttons that quit the game
@export var quit_buttons  : Array[QuitButton]

## Signals a scene to switch to
signal switch_scene(ref: FullSceneButton.GameSceneReference)
## Signals a submenu to be opened
signal open_subscene(ref: SubSceneButton.SubSceneReference)
## Signals the game needs to be quit
signal quit_game

## Propogates switch scene signal up
func _prop_switch_scene(ref: FullSceneButton.GameSceneReference) -> void:
	switch_scene.emit(ref)

## Propogates opneing subscene signal up
func _prop_open_subscene(ref: SubSceneButton.SubSceneReference) -> void:
	open_subscene.emit(ref)

## Propogates quit game signal up
func _prop_quit_game() -> void:
	quit_game.emit()

## Connects all defined buttons to their correct up-propogation signals.
func connect_all_buttons() -> void:
	for button in scene_buttons:
		button.switch_scene.connect(_prop_switch_scene)
	for button in subscene_buttons:
		button.open_subscene.connect(_prop_open_subscene)
	for button in quit_buttons:
		button.quit_game.connect(_prop_quit_game)

## Called when the scene is loaded. Inherited classes can use data to alter initialization
func load_scene(_pd: ProjectData) -> void:
	pass

## Called when the scene is unloaded. Inherited classes can alter what is saved.
func unload_scene(_pd: ProjectData) -> void:
	pass

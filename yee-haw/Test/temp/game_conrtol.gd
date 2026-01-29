extends Node2D

@export var scene1 : PackedScene
@export var scene2 : PackedScene

var _active_scene : ScenePreset
var _active_name : String
var _active_button : Button
var _callable : Callable

func _ready():
	load_scene_1()

func _remove_active_scene():
	if not _active_scene:
		return
	
	_active_button.pressed.disconnect(_callable)
	_active_scene.queue_free()

func load_scene_1():
	const scene_name = "SCENE 1"
	
	if _active_name == scene_name:
		return
	
	_remove_active_scene()
	
	_active_scene = scene1.instantiate() as ScenePreset
	_active_name = scene_name
	add_child(_active_scene)
	
	_active_button = _active_scene.button
	_active_button.pressed.connect(load_scene_2)
	_callable = load_scene_2

func load_scene_2():
	const scene_name = "SCENE 2"
	
	if _active_name == scene_name:
		return
	
	_remove_active_scene()
	
	_active_scene = scene2.instantiate() as ScenePreset
	_active_name = scene_name
	add_child(_active_scene)
	
	_active_button = _active_scene.button
	_active_button.pressed.connect(load_scene_1)
	_callable = load_scene_1

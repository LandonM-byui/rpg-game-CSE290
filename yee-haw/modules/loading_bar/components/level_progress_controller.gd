@tool
extends Control

## Controls the level progress bar to correctly animate as the player clears stages 
class_name LevelProgressController

## Total stages to clear
var _stages : int = 3
## Exposes [member _stages] to update the ui as it changes
@export var stages : int:
	get: return _stages
	set(value):
		_stages = max(1, value)
		_update_ui()

## Scene to use as the base node for level clearing
var _base_node : PackedScene
## Exposes [member _base_node] to update the ui as it changes
@export var base_node : PackedScene:
	get: return _base_node
	set(value):
		_base_node = value
		_update_ui()

## Scene to use as the boss node for level clearing
var _boss_node : PackedScene
## Exposes [member _boss_node] to update the ui as it changes
@export var boss_node : PackedScene:
	get: return _boss_node
	set(value):
		_boss_node = value
		_update_ui()

## Base color of non-active level nodes
var _deactivated_node_color : Color
## Exposes [member _deactivated_node_color] to update the ui as it changes
@export var deactivated_node_color : Color:
	get:
		return _deactivated_node_color
	set(value):
		_deactivated_node_color = value
		_update_ui()

## The color gradient across the bar as it progresses. Nodes are automatically 
## colored as they are cleared to match this gradient  
@export var slider_gradient : Gradient

@onready var _bar : TextureProgressBar = $"Progress Container/ProgressBar"
@onready var _node_container : Control = $"Progress Container/HBoxContainer"
@onready var _timer : Timer = $"Progress Container/ProgressBar/Timer"

## How fast the bar progresses while loading
@export var loading_speed : float = 3

## Tracked current level cleared
var _current_progress : int = 0
## Current bar progress, will smoothly increase until it reaches the [member _current_progress] value
var _progress_value : float = 0
## Stops animation when the [member _progress_value] reaches [member _current_progress]
var _caught_up := true
## Emitted when the bar is fully updated
signal bar_updated

## Updates all ui elements to dynamically adjust to the required nodes and levels
func _update_ui() -> void:
	if _boss_node == null or _base_node == null:
		return
	
	if _bar == null or _node_container == null:
		call_deferred("_update_ui")
		return
	
	_bar.max_value = float(_stages)
	var gradient_texture := GradientTexture2D.new()
	gradient_texture.gradient = slider_gradient
	gradient_texture.width = 980
	gradient_texture.height = 44
	_bar.texture_progress = gradient_texture
	
	if _node_container.get_child_count() > 0:
		for child in _node_container.get_children():
			child.queue_free()
	
	for _i in range(_stages - 1):
		var child := _base_node.instantiate()
		_node_container.add_child(child)
		(child as ProgressNode).set_node_color(_deactivated_node_color)
	
	var boss_child = _boss_node.instantiate()
	_node_container.add_child(boss_child)

## Returns true iff the [member _current_progress] < [member _stages]
func can_increase() -> bool:
	return float(_current_progress) < _bar.max_value

## Initialized the UI to animate an increased stage value
func increase_value() -> void:
	# timer creates a small delay to display UI before animating
	_timer.start()

## Actually applies the increased progress value to start animation
func _apply_increase_value() -> void:
	_current_progress += 1
	_caught_up = false

func _ready() -> void:
	_current_progress = 0
	_progress_value = 0
	_caught_up = true
	_bar.value = 0
	_timer.timeout.connect(_apply_increase_value)

func _process(delta) -> void:
	# no progress updates while in-engine editing
	if Engine.is_editor_hint():
		return
	
	# only animated is not caught up
	if _caught_up:
		return
	
	# smoothly progress bar value
	_progress_value = lerp(
		_progress_value, 
		float(_current_progress), 
		1.0 - exp(-loading_speed * delta)
	)
	
	# check if animation is complete when
	# _current_progress ~= _progress_value
	if abs(_current_progress - _progress_value) < 0.05:
		_progress_value = float(_current_progress)
		_caught_up = true
		bar_updated.emit()
		
		var prog_node = _node_container.get_child(_current_progress - 1) as ProgressNode
		var completion = (_progress_value / _bar.max_value)
		prog_node.set_node_color(slider_gradient.sample(completion))
	
	_bar.value = _progress_value

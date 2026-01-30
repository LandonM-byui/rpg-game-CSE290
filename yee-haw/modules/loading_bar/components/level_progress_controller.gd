@tool
extends Control
class_name LevelProgressController

var _stages : int = 3
@export var stages : int:
	get: return _stages
	set(value):
		_stages = max(1, value)
		_update_ui()

var _base_node : PackedScene
@export var base_node : PackedScene:
	get: return _base_node
	set(value):
		_base_node = value
		_update_ui()

var _boss_node : PackedScene
@export var boss_node : PackedScene:
	get: return _boss_node
	set(value):
		_boss_node = value
		_update_ui()

var _deactivated_node_color : Color
@export var deactivated_node_color : Color:
	get:
		return _deactivated_node_color
	set(value):
		_deactivated_node_color = value
		_update_ui()

@export var slider_gradient : Gradient

@onready var _bar : TextureProgressBar = $"Progress Container/ProgressBar"
@onready var _node_container : Control = $"Progress Container/HBoxContainer"
@onready var _timer : Timer = $"Progress Container/ProgressBar/Timer"

@export var loading_speed : float = 3

var _current_progress : int = 0
var _progress_value : float = 0
var _caught_up := true
signal bar_updated

func _update_ui():
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

func can_increase() -> bool:
	return float(_current_progress) < _bar.max_value

func increase_value() -> void:
	_timer.start()

func _apply_increase_value() -> void:
	_current_progress += 1
	_caught_up = false

func _ready():
	_current_progress = 0
	_progress_value = 0
	_caught_up = true
	_bar.value = 0
	_timer.timeout.connect(_apply_increase_value)

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	if _caught_up:
		return
	
	_progress_value = lerp(
		_progress_value, 
		float(_current_progress), 
		1.0 - exp(-loading_speed * delta)
	)
	
	if abs(_current_progress - _progress_value) < 0.05:
		_progress_value = float(_current_progress)
		_caught_up = true
		bar_updated.emit()
		
		var prog_node = _node_container.get_child(_current_progress - 1) as ProgressNode
		var completion = (_progress_value / _bar.max_value)
		prog_node.set_node_color(slider_gradient.sample(completion))
	
	_bar.value = _progress_value

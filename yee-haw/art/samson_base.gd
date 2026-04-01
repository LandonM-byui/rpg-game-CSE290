extends Node2D

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.set_current_animation("idle")
	animation_player.play()

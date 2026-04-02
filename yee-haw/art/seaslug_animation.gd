extends Node2D

@onready var animation_player = $AnimationPlayer




func _ready():
	self.position = Vector2(-10,-10)
	animation_player.set_current_animation("idle")
	animation_player.play()

extends Node2D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.set_current_animation("idle")
	animation_player.play()


func processing_test():
	var process = can_process()
	print(process)

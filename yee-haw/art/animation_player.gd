extends Node2D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.set_current_animation("idle")
	print('idle')
	animation_player.play()
	print('play')
	processing_test()
	print('ran processing test')

func processing_test():
	var process = can_process()
	print(process)

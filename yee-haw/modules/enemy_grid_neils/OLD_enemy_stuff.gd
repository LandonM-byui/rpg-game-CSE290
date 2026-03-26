extends Node2D

# using dodge the creeps tutorial as reference!
#$AnimatedSprite2D.animation = mob_type

#var enemy_scene : PackedScene

func node_test():
	var enemy_scene = $Enemy.instantiate()
	enemy_scene.position = Vector2(-300, -300)
	add_child(enemy_scene)


func _on_ready():
	node_test()

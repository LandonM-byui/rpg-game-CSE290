extends Node2D

'''assign this to enemy resource when instantiating the node!'''
var enemy_data : Enemy


func take_dmg(enemy_data,damage_value):
	'''take damage, using reference to enemy resource associated with this node'''
	'''call externally'''
	enemy_data.health = enemy_data.health - damage_value
	is_dead(enemy_data)


func is_dead(enemy_data):
	if enemy_data.health <= 0:
		queue_free()


func enemy_damage(enemy_data):
	'''call externally'''
	#num = ((randi() %2) +1.5 ) /3  #damage multiplyer between ~.5 and 1.5?
	var damage = enemy_data.attack    # * num
	return damage


func select():
	$cool_sprite.modulate = Color(1, 0, 0)


func unhighlight():
	$cool_sprite.modulate = Color(1, 1, 1)

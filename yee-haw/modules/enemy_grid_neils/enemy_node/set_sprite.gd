extends Sprite2D

'''Got this script from Microsoft Copilot at least as a stand in
		I got rid of all the errors like an hour ago and it still won't show up. Its 3am and I'm at my wits end  '''
# lame_sprite.gd (attach to the Sprite2D node)
#
@export var path: String

func _ready():
	if path != "":
		_apply_path(path)

func set_path(p: String) -> void:
	path = p
	_apply_path(p)

func _apply_path(p: String) -> void:
	if p == "":
		texture = null
		return
	var res = ResourceLoader.load(p)
	if not res:
		push_error("Failed to load texture at: " + str(p))
		return
	if not res is Texture2D:
		push_error("Loaded resource is not a Texture2D: " + str(res.get_class()))
		return
	texture = res as Texture2D
	print("Applied texture to sprite:", texture, "class:", texture.get_class())


#
#
#
#
#
#
#








'''Set this equal to enemy's associated sprite'''
##
#var path : String
#func _ready():
	#var new_texture = ResourceLoader.load(path) as Texture2D
	#texture = new_texture

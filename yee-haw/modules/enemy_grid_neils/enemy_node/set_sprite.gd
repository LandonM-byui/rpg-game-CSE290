extends Sprite2D

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
	var res := ResourceLoader.load(p)
	if not res:
		push_error("Failed to load texture at: " + str(p))
		return
	if not res is Texture2D:
		push_error("Loaded resource is not a Texture2D: " + str(res.get_class()))
		return
	texture = res as Texture2D

extends Camera2D

@export var board_path: NodePath

@onready var board := get_node(board_path) as Sprite2D

func _ready():
	var tex_size := board.texture.get_size()               # image pixels (e.g. 320x320)
	var world_size := Vector2(tex_size) * board.global_scale
	var half := world_size / 2.0

	limit_left = int(board.global_position.x - half.x)
	limit_right = int(board.global_position.x + half.x)
	limit_top = int(board.global_position.y - half.y)
	limit_bottom = int(board.global_position.y + half.y)

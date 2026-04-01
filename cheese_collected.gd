extends HBoxContainer

@export var cheese: PackedScene
var cheese_scene

func _on_tokens_received(tokens: int) -> void:
	tokens = tokens%6
	if cheese_scene == null or tokens == 6:
		cheese_scene = cheese.instantiate()
		add_child(cheese_scene)
	cheese_scene.region_rect = Rect2(32*tokens,0,32,32)
	print ("called")

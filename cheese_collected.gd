extends HBoxContainer

@export var cheese: PackedScene
var cheese_scene: AtlasTexture


func _on_tokens_received(tokens: int) -> void:
	tokens = tokens % 6
	print('tokens=%s' % tokens)

	if tokens == 0 and cheese_scene != null:
		cheese_scene.region = Rect2(32 * 6, 0, 32, 32)
		add_new_cheese_scene()
		return

	if cheese_scene == null:
		add_new_cheese_scene()

	cheese_scene.region = Rect2(32 * tokens, 0, 32, 32)


func add_new_cheese_scene() -> void:
	cheese_scene = AtlasTexture.new()
	cheese_scene.atlas = preload("res://sprite/Cheese_wheele.png")
	cheese_scene.region = Rect2(0, 0, 32, 32)

	var rect := TextureRect.new()
	rect.texture = cheese_scene
	rect.custom_minimum_size = Vector2(96, 32)
	add_child(rect)

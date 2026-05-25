extends Area2D

@export var value := 1
@export var respawn_delay := 3.0
@export var safe_margin := 32.0
@export var min_distance_from_player := 96.0

var collected := false
var player: Node2D
var spawn_id := 0

func _ready():
	body_entered.connect(_on_body_entered)
	player = get_tree().get_first_node_in_group("player")
	_respawn()

func _on_body_entered(body):
	if collected:
		return
	if body.is_in_group("player"):
		collected = true
		spawn_id += 1
		if body.has_method("add_tokens"):
			body.add_tokens(value)
		hide()
		monitoring = false
		await get_tree().create_timer(respawn_delay).timeout
		_respawn()
		
func _respawn():
	spawn_id += 1
	var my_id := spawn_id
	global_position = _random_valid_spawn_point()
	show()
	monitoring = true
	collected = false
	await get_tree().create_timer(respawn_delay).timeout
	if collected:
		return
	if spawn_id != my_id:
		return
	hide()
	monitoring = false
	_respawn()
	
func _random_valid_spawn_point() -> Vector2:
	
	var tries := 12
	
	while tries > 0:
		var p := _random_onscreen_world_point()
		if player == null:
			return p
		if p.distance_to(player.global_position) >= min_distance_from_player:
			return p
		tries -= 1
	return _random_onscreen_world_point()

func _random_onscreen_world_point() -> Vector2:
	var vp := get_viewport()
	var r := vp.get_visible_rect()
	
	var x := r.position.x + safe_margin + randf_range(0.0, r.size.x - safe_margin * 2.0)
	var y := r.position.y + safe_margin + randf_range(0.0, r.size.y - safe_margin * 2.0)

	return vp.get_canvas_transform().affine_inverse() * Vector2(x, y)

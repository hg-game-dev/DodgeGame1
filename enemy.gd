extends Area2D

@export var rush_speed = 1500
@export var retreat_speed := 350
@export var min_delay := 1
@export var max_delay := 3
@export var safe_margin := 32
@export var offscreen_margin := 120

var delay_left := 0.0
var state := 0
var destination:= Vector2.ZERO
var retreat_point := Vector2.ZERO

func _ready():
	
	body_entered.connect(_on_body_entered)
	monitoring = true
	monitorable = true
	delay_left = randf_range(min_delay,max_delay)
	state = 0

func _process(delta):
	if state == 0:
		delay_left -= delta
		if delay_left <= 0.0:
			destination = _random_onscreen_world_point()
			state = 1
	
	elif state == 1:
		global_position = global_position.move_toward(destination, rush_speed * delta)
		if global_position.distance_to(destination) <= 2:
			retreat_point = _random_offscreen_world_point()
			state = 2
	
	elif state == 2:
		global_position = global_position.move_toward(retreat_point, retreat_speed * delta)
		if global_position.distance_to(retreat_point) <= 2.0:
			delay_left = randf_range(min_delay,max_delay)
			state = 0

func _random_onscreen_world_point() -> Vector2:
	var vp := get_viewport()
	var r := vp.get_visible_rect()
	
	var x := r.position.x + safe_margin + randf_range(0.0, r.size.x - safe_margin * 2)
	var y := r.position.y + safe_margin + randf_range(0.0, r.size.y - safe_margin * 2)
	
	return vp.get_canvas_transform().affine_inverse() * Vector2(x, y)

func _random_offscreen_world_point() -> Vector2:
	var vp := get_viewport()
	var r := vp.get_visible_rect()
	
	var left := r.position.x - offscreen_margin
	var right := r.position.x + r.size.x + offscreen_margin
	var top := r.position.y - offscreen_margin
	var bottom := r.position.y + r.size.y + offscreen_margin
	
	var p: Vector2
	match randi() % 4:
		0: p = Vector2(randf_range(left, right), top)
		1: p = Vector2(randf_range(left, right), bottom)
		2: p = Vector2(left, randf_range(top, bottom))
		_: p = Vector2(right, randf_range(top, bottom))
		
	return vp.get_canvas_transform().affine_inverse() * p

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("lose_tokens"):
			body.lose_tokens(3)
		print("Caught!")

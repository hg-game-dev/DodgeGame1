extends CharacterBody2D

@export var speed = 600

var target = global_position
var tokens := 0

signal lives_changed(lives)
signal died

@export var max_lives := 3
var lives := 3

signal tokens_changed(tokens)
signal won

@export var slow_per_token := 10
@export var min_speed := 250

var wheels_awarded := 0

func _ready():
	lives = max_lives
	lives_changed.emit(lives)

func lose_life():
	lives = max(lives - 1, 0)
	lives_changed.emit(lives)
	if lives == 0:
		died.emit()

func on_caught():
	lose_life()

func add_tokens(amount):
	tokens += amount
	tokens_changed.emit(tokens)
	print("Tokens:", tokens)

	speed = max(speed - slow_per_token * amount, min_speed)

	var wheels_now := tokens / 6
	if wheels_now > wheels_awarded:
		var gained := wheels_now - wheels_awarded
		lives += gained
		wheels_awarded = wheels_now
		lives_changed.emit(lives)

	if tokens >= 30:
		won.emit()

func _input(event):
	if event.is_action_pressed(&"click"):
		target = get_global_mouse_position()
		target = clamp_to_board(target)
	if event is InputEventMouseMotion and Input.is_action_pressed(&"click"):
		target = get_global_mouse_position()
		target = clamp_to_board(target)
	look_at(get_global_mouse_position())
	
@export var board_center := Vector2(384, 700.709)
@export var board_size := Vector2(3040, 3040)

func clamp_to_board(p: Vector2) -> Vector2:
	var half := board_size / 2.0
	var min_x := board_center.x - half.x
	var min_y := board_center.y - half.y
	var max_x := board_center.x + half.x
	var max_y := board_center.y + half.y
	return Vector2(clamp(p.x, min_x, max_x), clamp(p.y, min_y, max_y))

func _physics_process(delta):
	velocity = global_position.direction_to(target) * speed
	if position.distance_to(target) > 10:
		move_and_slide()
	else:
		velocity = Vector2.ZERO

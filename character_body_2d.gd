extends CharacterBody2D

@export var speed = 600

var target = position

func _input(event):
	if event.is_action_pressed(&"click"):
		target = get_global_mouse_position()
	if event is InputEventMouseMotion and Input.is_action_pressed(&"click"):
		target = get_global_mouse_position()
	look_at(get_global_mouse_position())

func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	if position.distance_to(target) > 10:
		move_and_slide()

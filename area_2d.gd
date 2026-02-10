extends Area2D

@export var value := 1

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("add_tokens"):
			body.add_tokens(value)
		queue_free()

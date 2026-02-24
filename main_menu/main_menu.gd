class_name MainMenu
extends Control

@export var starting_scene: PackedScene

@onready var btn_new_game: Button


func receive_new_game_clicked() -> void:
	get_tree().change_scene_to_packed(starting_scene)

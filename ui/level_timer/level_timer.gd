class_name LevelTimer
extends Control

@onready var timer_display := %TimerDisplay

@export var is_enabled: bool = true 


var elapsed_time: float = 0.0


func _ready() -> void:
	receive_set_timer_status(is_enabled)
	
	
func _process(delta: float) -> void:
	elapsed_time += delta
	update_display()
	

func receive_set_timer_status(is_enabled: bool) -> void:
	process_mode = Node.PROCESS_MODE_INHERIT if is_enabled else Node.PROCESS_MODE_DISABLED
	
	
func receive_reset_timer() -> void:
	timer_display.text = ''
	

func update_display() -> void:
	var minutes: int = int(elapsed_time / 60)
	var seconds: int = int(elapsed_time) % 60
	var milliseconds: float = (elapsed_time * 100.0) as int % 100
	
	timer_display.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

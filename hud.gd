extends CanvasLayer

@onready var win_screen := $WinScreen
@onready var win_tokens_label := $WinScreen/FinalTokensLabel
@onready var lives_box := $LivesBox
@onready var cheese_collected := $CheeseCollected
@onready var partial1_collected := $CheeseCollected2
@onready var game_over := $GameOver
@onready var final_tokens_label := $GameOver/VBoxContainer/FinalTokensLabel
var player_ref

func _ready():
	game_over.visible = false
	win_screen.visible = false
	
	var candidates := get_tree().get_nodes_in_group("player")
	for c in candidates:
		if c.has_method("add_tokens") and c.has_method("lose_life"):
			connect_player(c)
			return

func connect_player(player):
	player_ref = player
	
	if player.has_signal("lives_changed") and not player.lives_changed.is_connected(_on_lives_changed):
		player.lives_changed.connect(_on_lives_changed)
	if player.has_signal("died") and not player.died.is_connected(_on_died):
		player.died.connect(_on_died)
	if player.has_signal("won") and not player.won.is_connected(_on_won):
		player.won.connect(_on_won)
	if player.has_signal("wheels_changed") and not player.wheels_changed.is_connected(_add_tokens):
		player.wheels_changed.connect(_add_tokens)
	if player.has_signal("partial1_changed") and not player.partial1_changed.is_connected(_add_partial1):
		player.partial1_changed.connect(_add_partial1)

	if "lives" in player:
		_on_lives_changed(player.lives)

func _on_lives_changed(lives):
	print("HUD lives:", lives)
	for i in range(lives_box.get_child_count()):
		lives_box.get_child(i).visible = i < lives

func _add_tokens(amount):
	for i in range(cheese_collected.get_child_count()):
		cheese_collected.get_child(i).visible = i < amount
		
func _add_partial1(amount):
	for i in range(partial1_collected.get_child_count()):
		partial1_collected.get_child(i).visible = i < amount

func _on_died():
	game_over.visible = true

	var token_count = 0
	if player_ref != null:
		var v = player_ref.get("tokens")
		if v != null:
			token_count = v

	final_tokens_label.text = "Cheese collected: %d" % token_count
	get_tree().paused = true

func _on_won():
	win_screen.visible = true

	var token_count = 0
	if player_ref != null:
		var v = player_ref.get("tokens")
		if v != null:
			token_count = v

	win_tokens_label.text = "Cheese collected: %d" % token_count

	get_tree().paused = true

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

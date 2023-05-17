extends Node2D

@onready var score_label: Label = get_node("ScoreLabel")
@onready var max_score_label: Label = get_node("MaxScoreLabel")
@onready var time_label: Label = get_node("TimeLabel")
@onready var background: ColorRect = get_node("BackgroundColor")
@onready var save_file = SaveFile.g_data

var score = 0
var time = 0
var max_score = 0
var background_color_index = 0
var background_colors = [
	Color(0.63, 0.91, 0.57)
]

var spawn_timer: Timer
var game_timer: Timer
var reverse_timer: Timer
var black_screen_timer: Timer
var enemy_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	$ReverseLabel.hide()
	max_score_label.set_text("Max Score: " + str(save_file.max_score))

	enemy_scene = load("res://scenes/enemies.tscn")
	spawn_timer = get_node("EnemiesTimer")
	spawn_timer.set_wait_time(2)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

	game_timer = get_node("GameTimer")
	game_timer.set_wait_time(1)
	game_timer.timeout.connect(update_time_label)
	game_timer.start()

	reverse_timer = get_node("ReverseTimer")
	reverse_timer.set_wait_time(5)
	reverse_timer.timeout.connect(handle_reverse_input)

	black_screen_timer = get_node("BlackScreenTimer")
	black_screen_timer.set_wait_time(5)
	black_screen_timer.timeout.connect(handle_black_screen)

	place_grid_on_screen()
	place_player_in_grid()
	place_labels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")


# Place the grid in the center of the screen
func place_grid_on_screen() -> void:
	var window_size = get_viewport().get_visible_rect().size
	var grid_position = Vector2(window_size.x / 2, window_size.y / 2)
	get_node("GridImage").set_position(grid_position)


# Place the player in the center of the grid
func place_player_in_grid() -> void:
	var window_size = get_viewport().get_visible_rect().size
	var grid_position = Vector2(window_size.x / 2, window_size.y / 2)
	get_node("Player").set_position(grid_position)


# Place all the labels in the grid
func place_labels() -> void:
	var window_size = get_viewport().get_visible_rect().size

	var score_label_size = score_label.get_size()
	var score_label_position = Vector2(window_size.x / 2 - score_label_size.x / 2, 30)
	score_label.set_position(score_label_position)

	var max_score_label_size = max_score_label.get_size()
	var max_score_label_position = Vector2(30, 30)
	max_score_label.set_position(max_score_label_position)

	var time_label_size = time_label.get_size()
	var time_label_position = Vector2(window_size.x - time_label_size.x - 90, 30)
	time_label.set_position(time_label_position)


# Spawn an enemy
func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	# set enemy ordering z to 1
	enemy.set_z_index(1)
	add_child(enemy)
	score += 1
	score_label.set_text("Score: " + str(score))
	if score % 10 == 0:
		update_background_color()
	if score % 5 == 0 and save_file.difficulty >= 1:
		if randi_range(0, 1) == 1:
			reverse_timer.start()
			Global.reverse = true
			$ReverseLabel.show()
		if save_file.difficulty >= 2 and randi_range(0, 1) == 1:
			black_screen_timer.start()
			$BlackScreen.show()
			
	spawn_timer.set_wait_time((-1.0 / 100.0) * time + 2)


func handle_reverse_input():
	Global.reverse = false
	reverse_timer.stop()
	$ReverseLabel.hide()

func handle_black_screen():
	black_screen_timer.stop()
	$BlackScreen.hide()

# Reset the game to the initial state
func game_over() -> void:
	handle_death()
	await get_tree().create_timer(2).timeout
	# Save the max score
	save_file.last_score = score
	save_file.max_score = score if score > save_file.max_score else save_file.max_score
	save_file.coins += score
	SaveFile.save_data()
	max_score_label.set_text("Max Score: " + str(save_file.max_score))
	score = 0
	background_color_index = 1
	score_label.set_text("Score: " + str(score))
	background_color_index = 0
	background.set_color(background_colors[background_color_index])
	# Kill all enemies
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	# Reset the player position
	place_player_in_grid()
	get_node("Player").x = 0
	get_node("Player").y = 0
	# Reset the spawn timer
	spawn_timer.set_wait_time(2)
	# Reset the game timer
	time = 0
	time_label.set_text("Time: 0s")
	# Reset the reverse timer
	reverse_timer.stop()
	Global.reverse = false
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")


func handle_death() -> void:
	get_node("Player").dead = true
	get_node("Player").play_death_animation()
	

# Update the background color every 20 score points
func update_background_color() -> void:
	var new_color = background_colors[background_color_index]
	background_color_index = (background_color_index + 1) % background_colors.size()
	background.set_color(new_color)


# Update the time label
func update_time_label() -> void:
	time += 1
	time_label.set_text("Time: " + str(time) + "s")

extends Node2D

@onready var score_label: Label = get_node("ScoreLabel")
@onready var max_score_label: Label = get_node("MaxScoreLabel")
@onready var time_label: Label = get_node("TimeLabel")
@onready var background: ColorRect = get_node("BackgroundColor")

const SAVE_FILE = "user://save_file.save"
var g_data = {
	"max_score": 0,
	"coins": 0
}

var score = 0
var time = 0
var max_score = 0
var background_color_index = 1
var background_colors = [
	Color(0.63, 0.91, 0.57),
	Color(1.0, 0.3, 0.2),
	Color(0.6, 1, 0.6),
	Color(1.0, 0.3, 1.0),
	Color(0.0, 0.5, 0.5),
	Color(0.75, 0.75, 0.75),
	Color(0.5, 0.5, 0.5),
	Color(1.0, 0.85, 1.0),
	Color(1.0, 1.0, 0.58),
	Color(0.58, 1.0, 1.0),
	Color(0.86, 0.86, 0.86),
	Color(0.66, 0.66, 0.66),
	Color(0.94, 0.90, 0.54),
	Color(0.96, 0.96, 0.96),
	Color(0.43, 0.50, 0.56),
	Color(0.82, 0.70, 0.54),
	Color(0.98, 0.94, 0.90),
	Color(0.41, 0.41, 0.41),
	Color(0.82, 0.82, 0.82),
	Color(0.56, 0.93, 0.56)
]

var spawn_timer: Timer
var game_timer: Timer
var enemy_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()
	max_score_label.set_text("Max Score: " + str(g_data["max_score"]))

	enemy_scene = load("res://scenes/enemies.tscn")
	spawn_timer = get_node("EnemiesTimer")
	spawn_timer.set_wait_time(2)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

	game_timer = get_node("GameTimer")
	game_timer.set_wait_time(1)
	game_timer.timeout.connect(update_time_label)
	game_timer.start()

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

	var max_score_label_size  = max_score_label.get_size()
	var max_score_label_position = Vector2(30, 30)
	max_score_label.set_position(max_score_label_position)

	var time_label_size = time_label.get_size()
	var time_label_position = Vector2(window_size.x - time_label_size.x - 90, 30)
	time_label.set_position(time_label_position)


# Spawn an enemy
func _on_spawn_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	score += 1
	score_label.set_text("Score: " + str(score))
	if score % 10 == 0:
		update_background_color()
	spawn_timer.set_wait_time((-1.0 / 100.0) * time + 2)


# Reset the game to the initial state
func game_over() -> void:
	# Save the max score
	g_data["max_score"] = score if score > g_data["max_score"] else g_data["max_score"]
	g_data["coins"] += score
	save_data()
	max_score_label.set_text("Max Score: " + str(g_data["max_score"]))
	
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
	

# Update the background color every 20 score points
func update_background_color() -> void:
	var new_color = background_colors[background_color_index]
	background_color_index = (background_color_index + 1) % background_colors.size()
	background.set_color(new_color)


# Load the data from the save file
func load_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		save_data()
	else:
		file.open(SAVE_FILE, FileAccess.READ)
		g_data = file.get_var()
		file.close()


# Save the data to the save file
func save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_var(g_data)
	file.close()


# Update the time label
func update_time_label() -> void:
	time += 1
	time_label.set_text("Time: " + str(time) + "s")

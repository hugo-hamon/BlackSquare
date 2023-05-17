extends Control

var save_file: Dictionary
var coin_count = 0
var inputs = []


# Called when the node enters the scene tree for the first time.
func _ready():
	SaveFile.load_data()
	save_file = SaveFile.g_data
	$VBoxContainer/StartButton.grab_focus()
	# set window size to 800x600
	get_viewport().size = Vector2(1000, 667)
	get_node("CoinsLabel").set_text(str(save_file.coins))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("up"):
		inputs.append("up")
	if Input.is_action_just_pressed("down"):
		inputs.append("down")
	if Input.is_action_just_pressed("left"):
		inputs.append("left")
	if Input.is_action_just_pressed("right"):
		inputs.append("right")
	if inputs == ["up", "up", "down", "down", "left", "right", "left", "right"]:
		SaveFile.reset_data()
		SaveFile.load_data()
		save_file = SaveFile.g_data
		get_node("CoinsLabel").set_text(str(save_file.coins))
		inputs = []
	if Input.is_action_just_pressed("escape") or inputs.size() > 8:
		inputs = []

# Called when the start button is pressed
func _on_start_button_pressed():
	get_viewport().size = Vector2(1000, 1000)
	get_tree().change_scene_to_file("res://scenes/main.tscn")


# Called when the quit button is pressed
func _on_quit_button_pressed():
	get_tree().quit()


func _on_slime_button_pressed():
	get_tree().change_scene_to_file("res://scenes/slime_shop.tscn")


func _on_difficulty_button_pressed():
	get_tree().change_scene_to_file("res://scenes/difficulty_menu.tscn")


func _on_mode_button_pressed():
	get_tree().change_scene_to_file("res://scenes/mod_menu.tscn")

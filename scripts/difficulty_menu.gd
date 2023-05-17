extends Control

var save_file: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	set_focus_mode(FOCUS_NONE)
	SaveFile.load_data()
	save_file = SaveFile.g_data
	get_node("CoinsLabel").set_text(str(save_file.coins))
	update_button_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")


func update_button_color():
	$VBoxContainer/EasyButton.set("theme_override_colors/font_color", Color(1, 1, 1))
	$VBoxContainer/NormalButton.set("theme_override_colors/font_color", Color(1, 1, 1))
	$VBoxContainer/HardButton.set("theme_override_colors/font_color", Color(1, 1, 1))
	if save_file.difficulty == 0:
		$VBoxContainer/EasyButton.set("theme_override_colors/font_color", Color(0.97, 0, 0.11))
	elif save_file.difficulty == 1:
		$VBoxContainer/NormalButton.set("theme_override_colors/font_color", Color(0.97, 0, 0.11))
	elif save_file.difficulty == 2:
		$VBoxContainer/HardButton.set("theme_override_colors/font_color", Color(0.97, 0, 0.11))



func _on_easy_button_pressed():
	save_file.difficulty = 0
	SaveFile.save_data()
	update_button_color()


func _on_normal_button_pressed():
	save_file.difficulty = 1
	SaveFile.save_data()
	update_button_color()


func _on_hard_button_pressed():
	save_file.difficulty = 2
	SaveFile.save_data()
	update_button_color()

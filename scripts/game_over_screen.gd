extends Control

var save_file: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	SaveFile.load_data()
	save_file = SaveFile.g_data
	# set score label
	$ScoreLabel.text = "SCORE: " + str(save_file.last_score)

	# set window size to 800x600
	get_viewport().size = Vector2(1000, 667)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	get_viewport().size = Vector2(1000, 1000)
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

extends Control

var save_file: Dictionary
var coin_count = 0


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
	pass

# Called when the start button is pressed
func _on_start_button_pressed():
	get_viewport().size = Vector2(1000, 1000)
	get_tree().change_scene_to_file("res://scenes/main.tscn")


# Called when the quit button is pressed
func _on_quit_button_pressed():
	get_tree().quit()


func _on_slime_button_pressed():
	get_tree().change_scene_to_file("res://scenes/slime_shop.tscn")

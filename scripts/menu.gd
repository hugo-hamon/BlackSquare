extends Control

const SAVE_FILE = "user://save_file.save"
var coin_count = 0
var data = {
	"max_score": 0,
	"coins": 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()
	# set window size to 800x600
	get_viewport().size = Vector2(1000, 667)
	update_coin_count(coin_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Read coins count from file
func _read_coins_count():
	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		save_data()
	else:
		file.open(SAVE_FILE, FileAccess.READ)
		var data = file.get_var()

# Save the data to the save file
func save_data():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_var(data)
	file.close()


# Called to update the coin count
func update_coin_count(coin_count):
	_read_coins_count()
	get_node("CoinsLabel").set_text(str(data["coins"]))


# Called when the start button is pressed
func _on_start_button_pressed():
	get_viewport().size = Vector2(1000, 1000)
	get_tree().change_scene_to_file("res://scenes/main.tscn")


# Called when the quit button is pressed
func _on_quit_button_pressed():
	get_tree().quit()

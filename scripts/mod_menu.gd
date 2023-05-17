extends Control

var save_file: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	SaveFile.load_data()
	save_file = SaveFile.g_data
	get_node("CoinsLabel").set_text(str(save_file.coins))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

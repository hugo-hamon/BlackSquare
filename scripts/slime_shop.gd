extends Control

var save_file: Dictionary
var turn_left = false
@onready var frame_texture = get_tree().get_nodes_in_group("slimeFrame")
@onready var slime_texture = get_tree().get_nodes_in_group("slimeShopIdle")


# Called when the node enters the scene tree for the first time.
func _ready():
	SaveFile.load_data()
	save_file = SaveFile.g_data
	get_node("CoinsLabel").set_text(str(save_file.coins))
	play_animation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	set_rotate_pivot()


# Set the pivot of the frame_texture to the center of the frame_texture and rotate them
func set_rotate_pivot():
	var size = frame_texture[0].get_size()
	size *= frame_texture[0].get_scale()
	var pivot = Vector2(size.x / 2, size.y / 2)
	for i in frame_texture:
		i.set_pivot_offset(pivot)
	for i in frame_texture:
		if turn_left:
			i.set_rotation(i.get_rotation() - 0.002)
		else:
			i.set_rotation(i.get_rotation() + 0.002)
	if frame_texture[0].get_rotation() > 0.4:
		turn_left = true
	elif frame_texture[0].get_rotation() < -0.4:
		turn_left = false


# Switch to the slime select
func select_slime(name):
	save_file.picked_slime = name
	SaveFile.save_data()


# Play animation of slime
func play_animation():
	for i in slime_texture:
		i.play("Idle")
		i.set_flip_h(true)


# Buy green slime
func _on_green_slime_button_pressed():
	buy_slime("green", 0)


# Buy gray slime
func _on_gray_slime_button_pressed():
	buy_slime("gray", 200)


# Buy blue slime
func _on_blue_slime_button_pressed():
	buy_slime("blue", 350)

# Buy brown slime
func _on_brown_slime_button_pressed():
	buy_slime("brown", 400)

# Buy orange slime
func _on_orange_slime_button_pressed():
	buy_slime("orange", 500)

# Buy red slime
func _on_red_slime_button_pressed():
	buy_slime("red", 650)

# Buy yellow slime
func _on_yellow_slime_button_pressed():
	buy_slime("yellow", 1000)


# Buy slime of a given color
func buy_slime(color: String, cost: int):
	if color not in save_file.slimes and save_file.coins >= cost:
		save_file.coins -= cost
		save_file.slimes.append(color)
		SaveFile.save_data()
		get_node("CoinsLabel").set_text(str(save_file.coins))
	if color in save_file.slimes:
		select_slime(color)

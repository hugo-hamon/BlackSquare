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


# Play animation of slime
func play_animation():
	for i in slime_texture:
		i.play("Idle")
		i.set_flip_h(true)


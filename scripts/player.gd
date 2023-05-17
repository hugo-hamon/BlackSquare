extends CharacterBody2D

var save_file: Dictionary
var move_distance = 0
var dead = false
var x = 0
var y = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SaveFile.load_data()
	save_file = SaveFile.g_data
	move_distance = compute_move_distance()
	var sprite = get_node("AnimatedSprite2D")
	sprite.play(save_file.picked_slime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	process_input(move_distance)


# Play death animation
func play_death_animation() -> void:
	get_node("AnimatedSprite2D").play(save_file.picked_slime + "_death")


# Process input and move the character
func process_input(move_distance: int) -> void:
	if dead:
		return
	if Global.reverse:
		process_reverse_input(move_distance)
		return
	if Input.is_action_just_pressed("up") and y < 1:
		# set animation speed
		global_position.y -= move_distance
		y += 1
	elif Input.is_action_just_pressed("down") and y > -1:
		global_position.y += move_distance
		y -= 1
	elif Input.is_action_just_pressed("left") and x > -1:
		global_position.x -= move_distance
		get_node("AnimatedSprite2D").set_flip_h(false)
		x -= 1
	elif Input.is_action_just_pressed("right") and x < 1:
		global_position.x += move_distance
		get_node("AnimatedSprite2D").set_flip_h(true)
		x += 1


# Process reverse input and move the character
func process_reverse_input(move_distance: int) -> void:
	if Input.is_action_just_pressed("up") and y > -1:
		global_position.y += move_distance
		y -= 1
	elif Input.is_action_just_pressed("down") and y < 1:
		global_position.y -= move_distance
		y += 1
	elif Input.is_action_just_pressed("left") and x < 1:
		global_position.x += move_distance
		get_node("AnimatedSprite2D").set_flip_h(true)
		x += 1
	elif Input.is_action_just_pressed("right") and x > -1:
		global_position.x -= move_distance
		get_node("AnimatedSprite2D").set_flip_h(false)
		x -= 1

# Compute the distance to move relatively to the grid size
func compute_move_distance() -> int:
	var grid_size = (
		get_node("/root/Main/GridImage").get_rect().size.x
		* get_node("/root/Main/GridImage").get_transform().get_scale().x
	)
	return int(round(grid_size / 3 - 3))

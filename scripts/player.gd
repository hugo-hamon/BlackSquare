extends CharacterBody2D

var move_distance = 0
var x = 0
var y = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_distance = compute_move_distance()
	var sprite = get_node("AnimatedSprite2D")
	sprite.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	process_input(move_distance)


# Process input and move the character
func process_input(move_distance: int) -> void:
	if Input.is_action_just_pressed("up") and y < 1:
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


# Compute the distance to move relatively to the grid size
func compute_move_distance() -> int:
	var grid_size = (
		get_node("/root/Main/GridImage").get_rect().size.x
		* get_node("/root/Main/GridImage").get_transform().get_scale().x
	)
	return int(round(grid_size / 3 - 3))

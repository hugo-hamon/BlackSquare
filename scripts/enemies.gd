extends CharacterBody2D

var direction = Vector2(0, 0)
var grid_center = Vector2(0, 0)
var start_position = Vector2(0, 0)
var speed: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite = get_node("AnimatedSprite2D")
	sprite.play("Enemy1")

	speed = randf_range(100, 200)
	grid_center = Vector2(
		get_viewport().get_visible_rect().size.x / 2, get_viewport().get_visible_rect().size.y / 2
	)
	var random_position = get_random_position()
	global_position = random_position[0]
	start_position = random_position[0]
	direction = random_position[1]
	rotate_to_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity = direction * speed
	var collide = move_and_collide(velocity * delta)
	if collide:
		var main_node = get_node("/root/Main")
		main_node.call_deferred("game_over")
		queue_free()
	if global_position.distance_to(start_position) > 1200:
		queue_free()


# Return a random position on the edge of the screen
func get_random_position() -> Array:
	var grid_size = (
		get_node("/root/Main/GridImage").get_rect().size.x
		* get_node("/root/Main/GridImage").get_transform().get_scale().x
	)
	var move_distance = grid_size / 3 - 3
	# position is a list of tuple (position, velocity)
	var lower_boud = -100
	var upper_bound = 1100
	var positions = [
		[Vector2(grid_center.x, lower_boud), Vector2(0, 1)],
		[Vector2(grid_center.x - move_distance, lower_boud), Vector2(0, 1)],
		[Vector2(grid_center.x + move_distance, lower_boud), Vector2(0, 1)],
		[Vector2(grid_center.x, upper_bound), Vector2(0, -1)],
		[Vector2(grid_center.x - move_distance, upper_bound), Vector2(0, -1)],
		[Vector2(grid_center.x + move_distance, upper_bound), Vector2(0, -1)],
		[Vector2(lower_boud, grid_center.y), Vector2(1, 0)],
		[Vector2(lower_boud, grid_center.y - move_distance), Vector2(1, 0)],
		[Vector2(lower_boud, grid_center.y + move_distance), Vector2(1, 0)],
		[Vector2(upper_bound, grid_center.y), Vector2(-1, 0)],
		[Vector2(upper_bound, grid_center.y - move_distance), Vector2(-1, 0)],
		[Vector2(upper_bound, grid_center.y + move_distance), Vector2(-1, 0)],
	]
	return positions[randi() % positions.size()]

# Rotate the enemy to face the grid
func rotate_to_player() -> void:
	if direction == Vector2(0, 1):
		rotation_degrees = 90
	elif direction == Vector2(0, -1):
		rotation_degrees = -90
	elif direction == Vector2(1, 0):
		rotation_degrees = 0
	elif direction == Vector2(-1, 0):
		rotation_degrees = 180
		# flip horizontally
		get_node("AnimatedSprite2D").flip_v = true

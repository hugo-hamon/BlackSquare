extends CharacterBody2D

@export var sprite_name = "Green"

const SPEED = 50
var start_position = Vector2(0, 0)

var target = Vector2(0, 0)
var move_timer: Timer
var sprite: AnimatedSprite2D
var moving = false


func _ready():
	move_timer = get_node("MoveTimer")
	move_timer.set_wait_time(randf_range(2, 5))
	move_timer.timeout.connect(move_random)
	move_timer.start()

	sprite = get_node("AnimatedSprite2D")
	sprite.set_animation(sprite_name)
	sprite.play()
	sprite.flip_h = randi() % 2 == 0

	start_position = $".".global_position


func _physics_process(delta):
	if moving:
		go_to(delta)


func move_random():
	var rand_x = randi_range(start_position.x - 100, start_position.x + 100)
	target = Vector2(rand_x, start_position.y)
	moving = true
	move_timer.set_wait_time(randf_range(2, 5))
	move_timer.stop()
	if rand_x > $".".global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	# randomly trigger a jump
	if randi() % 3 == 0:
		sprite.set_animation(sprite_name + "Jump")
		sprite.play()
	else:
		sprite.set_animation(sprite_name)
		sprite.play()


func go_to(delta):
	if moving:
		$".".global_position = $".".global_position.move_toward(target, delta * SPEED)
	if $".".global_position == target:
		moving = false
		move_timer.start()

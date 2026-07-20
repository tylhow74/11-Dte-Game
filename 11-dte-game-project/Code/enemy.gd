extends CharacterBody2D

const SPEED = 80
const GRAVITY = 900

var direction = 1

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.x = SPEED * direction

	move_and_slide()

	if is_on_wall():
		direction *= -1

	# Flip the enemy
	animated_sprite.flip_h = direction > 0

	# Play walking animation
	animated_sprite.play("walk")

	# Check if enemy touched player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body.name == "Player":
			body.take_damage(10)

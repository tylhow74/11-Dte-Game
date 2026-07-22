extends CharacterBody2D

const SPEED = 80
const GRAVITY = 900

var direction = 1
var health = 3

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Move
	velocity.x = SPEED * direction

	move_and_slide()

	# Turn around
	if is_on_wall():
		direction *= -1

	# Flip sprite
	animated_sprite.flip_h = direction > 0

	# Play animation
	animated_sprite.play("walk")

# Check if enemy touched player
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body.name == "Player":
			body.take_damage(10)

func take_damage(amount):
	health -= amount
	print("Enemy HP:", health)

	if health <= 0:
		die()


func die():
	print("Enemy died")
	queue_free()

func _on_stomp_area_body_entered(body):
	print("Something entered:", body.name)

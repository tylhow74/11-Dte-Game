extends CharacterBody2D

const SPEED = 80
const GRAVITY = 900

var direction = 1
var health = 3
var can_damage = true

@onready var animated_sprite = $AnimatedSprite2D
@onready var hp_bar = $ProgressBar


func _ready():

	hp_bar.max_value = health
	hp_bar.value = health

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.x = SPEED * direction

	move_and_slide()


	if is_on_wall():
		direction *= -1


	animated_sprite.flip_h = direction > 0
	animated_sprite.play("walk")


	# Player damage
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body.is_in_group("player") and can_damage:
			can_damage = false
			body.take_damage(10)

			await get_tree().create_timer(0.5).timeout
			can_damage = true

func _on_stomparea_body_entered(body: Node2D) -> void:

	print("STOMP SIGNAL:", body.name)

	if body.is_in_group("player"):

		print("DAMAGING ENEMY")

		health -= 1

		print("Enemy HP:", health)

		body.bounce()

		if health <= 0:
			queue_free()

func take_damage(amount):

	print("Enemy took damage:", amount)

	health -= amount

	print("Current HP:", health)

	hp_bar.value = health

	if health <= 0:
		die()

func die():

	print("Enemy died")
	queue_free()

extends CharacterBody2D

const SPEED = 80
const GRAVITY = 900

const BANANA_SCENE = preload("res://Assets/banana.tscn") # Change this to your Banana.tscn path

var direction = 1
var health = 3
var can_damage = true

# Turn every 2 seconds
var turn_timer = 0.0
var turn_interval = 2.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var hp_bar = $ProgressBar

func _ready():
	hp_bar.max_value = health
	hp_bar.value = health

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Turn around every 2 seconds
	turn_timer += delta
	if turn_timer >= turn_interval:
		direction *= -1
		turn_timer = 0.0

	velocity.x = SPEED * direction

	move_and_slide()

	animated_sprite.flip_h = direction > 0
	animated_sprite.play("walk")

	# Damage the player
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var body = collision.get_collider()

		if body.is_in_group("player") and can_damage:
			can_damage = false
			body.take_damage(25)

			await get_tree().create_timer(0.5).timeout
			can_damage = true

func _on_stomparea_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		health -= 1
		hp_bar.value = health

		body.bounce()

		if health <= 0:
			die()

func take_damage(amount):
	health -= amount
	hp_bar.value = health

	if health <= 0:
		die()

func die():
	print("Enemy died")

	var banana = BANANA_SCENE.instantiate()
	banana.global_position = global_position
	get_parent().add_child(banana)

	queue_free()

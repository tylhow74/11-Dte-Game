extends CharacterBody2D

const NORMAL_SPEED = 200
const WATER_SPEED = 100

const NORMAL_GRAVITY = 900
const WATER_GRAVITY = 200

const NORMAL_JUMP = -350
const WATER_JUMP = -150

var speed = NORMAL_SPEED
var gravity = NORMAL_GRAVITY
var jump_force = NORMAL_JUMP

var in_water = false

var max_health = 100
var health = 100

@onready var anim = $AnimatedSprite2D
@onready var hp_bar = $ProgressBar
@onready var bananas = %BananaLabel

func add_banana():
	bananas += 1
	banana_label.text = "Bananas: " + str(bananas)

func _ready():
	hp_bar.min_value = 0
	hp_bar.max_value = max_health
	hp_bar.value = health

func take_damage(amount):
	health -= amount
	health = clamp(health, 0, max_health)

	hp_bar.value = health

	print("HP:", health)

	if health <= 0:
		die()

func heal(amount):
	health += amount
	health = clamp(health, 0, max_health)

	hp_bar.value = health

func die():
	print("Game Over")
	queue_free()

func _physics_process(delta):

	# Water physics
	if in_water:
		speed = WATER_SPEED
		gravity = WATER_GRAVITY
		jump_force = WATER_JUMP
	else:
		speed = NORMAL_SPEED
		gravity = NORMAL_GRAVITY
		jump_force = NORMAL_JUMP

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	# Movement
	var direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# Flip sprite
	if direction != 0:
		anim.flip_h = direction < 0

	# Animations
	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("run")
	else:
		anim.play("idle")

	move_and_slide()

func _on_water_body_entered(body):
	if body == self:
		in_water = true

func _on_water_body_exited(body):
	if body == self:
		in_water = false

extends CharacterBody2D

const SPEED = 200
const GRAVITY = 900
const JUMP_FORCE = -350

@onready var anim = $AnimatedSprite2D

func _physics_process(delta):

	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE

	# Movement
	var direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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

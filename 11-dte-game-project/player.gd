extends CharacterBody2D

const NORMAL_SPEED = 200.0
const WATER_SPEED = 100.0

const NORMAL_GRAVITY = 900.0
const WATER_GRAVITY = 200.0

const NORMAL_JUMP = -375
const WATER_JUMP = -150.0

var speed = NORMAL_SPEED
var gravity = NORMAL_GRAVITY
var jump_force = NORMAL_JUMP

var in_water = false

var max_health = 100
var health = 100
var invincible = false

var banana_count = 0

@onready var anim = $AnimatedSprite2D
@onready var hp_bar = $ProgressBar
@onready var banana_label = $"../CanvasLayer/BananaLabel"


func _ready():
	hp_bar.min_value = 0
	hp_bar.max_value = max_health
	hp_bar.value = health

	update_banana_ui()


# ---------------- MOVEMENT ----------------

func _physics_process(delta):
	check_water()

	if in_water:
		speed = WATER_SPEED
		gravity = WATER_GRAVITY
		jump_force = WATER_JUMP

		if velocity.y > 100:
			velocity.y = 100
	else:
		speed = NORMAL_SPEED
		gravity = NORMAL_GRAVITY
		jump_force = NORMAL_JUMP

	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		velocity.x = direction * speed
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed * 8 * delta)

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or in_water:
			velocity.y = jump_force

	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("run")
	else:
		anim.play("idle")

	move_and_slide()


# ---------------- WATER ----------------

func check_water():
	in_water = false

	var space_state = get_world_2d().direct_space_state

	var params = PhysicsPointQueryParameters2D.new()
	params.position = global_position
	params.collide_with_areas = true

	var hits = space_state.intersect_point(params)

	for hit in hits:
		var collider = hit.collider
		if collider and collider.is_in_group("water"):
			in_water = true
			return


# ---------------- BANANAS ----------------

func add_banana():
	banana_count += 1
	update_banana_ui()


func update_banana_ui():
	if banana_label:
		banana_label.text = "Bananas: " + str(banana_count)


# ---------------- DAMAGE ----------------

func take_damage(amount):
	if invincible:
		return

	invincible = true

	health -= amount
	health = clamp(health, 0, max_health)

	hp_bar.value = health

	flash_red()

	if health <= 0:
		die()
		return

	await get_tree().create_timer(0.5).timeout
	invincible = false


func flash_red():
	for i in range(3):
		anim.modulate = Color(1, 0.2, 0.2)
		await get_tree().create_timer(0.05).timeout
		anim.modulate = Color.WHITE
		await get_tree().create_timer(0.05).timeout


func die():
	queue_free()

extends CharacterBody2D

const NORMAL_SPEED = 200.0
const WATER_SPEED = 100.0
const SPEED_BOOST = 10000.0

const NORMAL_GRAVITY = 900.0
const WATER_GRAVITY = 200.0
const SPACE_GRAVITY = 150.0

const NORMAL_JUMP = -375
const WATER_JUMP = -150.0
const SPACE_JUMP = -250.0

const CLIMB_SPEED = 150.0

# FLYING
const FLY_SPEED = 500.0

var speed = NORMAL_SPEED
var gravity = NORMAL_GRAVITY
var jump_force = NORMAL_JUMP

var in_water = false
var in_space = false

# Flying
var flying = false

# Speed boost
var speed_boost = false

var max_health = 100
var health = 100

var invincible = false
var dead = false

var banana_count = 0

# Climbing
var can_climb = false
var wall_climbing = false


@onready var anim = $AnimatedSprite2D
@onready var hp_bar = $ProgressBar
@onready var banana_label = $"../CanvasLayer/BananaLabel"

# TIMER
@onready var timer = $Timer
@onready var label = $Label


func _ready():

	hp_bar.min_value = 0
	hp_bar.max_value = max_health
	hp_bar.value = health

	update_banana_ui()

	label.position = Vector2(-20, -200)

	timer.start()


func _physics_process(delta):

	if dead:
		return

	check_water()


	# --------------------------------
	# FLY TOGGLE
	# --------------------------------

	if Input.is_action_just_pressed("fly"):
		toggle_fly()


	# --------------------------------
	# SPEED BOOST TOGGLE
	# --------------------------------

	if Input.is_action_just_pressed("speed_boost"):
		toggle_speed()


	# --------------------------------
	# MOVEMENT SETTINGS
	# --------------------------------

	if in_space:

		gravity = SPACE_GRAVITY
		jump_force = SPACE_JUMP

	elif in_water:

		gravity = WATER_GRAVITY
		jump_force = WATER_JUMP

	else:

		gravity = NORMAL_GRAVITY
		jump_force = NORMAL_JUMP


	# --------------------------------
	# SPEED
	# --------------------------------

	if speed_boost:

		speed = SPEED_BOOST

	elif in_water:

		speed = WATER_SPEED

	else:

		speed = NORMAL_SPEED


	# --------------------------------
	# VINE CLIMBING
	# --------------------------------

	if can_climb and not flying:

		if Input.is_action_pressed("move_up"):

			velocity.y = -CLIMB_SPEED

		elif Input.is_action_pressed("move_down"):

			velocity.y = CLIMB_SPEED

		else:

			velocity.y = 0


	# --------------------------------
	# WALL CLIMBING
	# --------------------------------

	wall_climbing = false

	if not flying:

		if is_on_wall() and Input.is_action_pressed("move_up"):

			wall_climbing = true
			velocity.y = -CLIMB_SPEED


	# --------------------------------
	# FLYING / GRAVITY
	# --------------------------------

	if flying:

		# W = UP
		# S = DOWN

		var fly_direction = Input.get_axis("move_down", "move_up")

		if fly_direction != 0:

			velocity.y = fly_direction * FLY_SPEED

		else:

			# Stay in the air
			velocity.y = 0

	else:

		# Normal gravity

		if not is_on_floor() and not wall_climbing and not can_climb:

			velocity.y += gravity * delta


	# --------------------------------
	# HORIZONTAL MOVEMENT
	# --------------------------------

	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:

		velocity.x = direction * speed
		anim.flip_h = direction < 0

	else:

		velocity.x = 0


	# --------------------------------
	# JUMP
	# --------------------------------

	if Input.is_action_just_pressed("jump") and not flying:

		if is_on_floor() or in_water:

			velocity.y = jump_force


	# --------------------------------
	# ANIMATION
	# --------------------------------

	if not is_on_floor():

		anim.play("jump")

	elif direction != 0:

		anim.play("run")

	else:

		anim.play("idle")


	move_and_slide()


func _process(delta):

	label.text = str(ceil(timer.time_left))


# --------------------------------
# FLYING
# --------------------------------

func toggle_fly():

	flying = !flying

	if flying:

		print("FLY ON")

		# Immediately launch into the air
		velocity.y = -FLY_SPEED

	else:

		print("FLY OFF")


# --------------------------------
# SPEED BOOST
# --------------------------------

func toggle_speed():

	speed_boost = !speed_boost

	if speed_boost:

		print("SPEED BOOST ON")

	else:

		print("SPEED BOOST OFF")


# --------------------------------
# TIMER
# --------------------------------

func _on_timer_timeout():

	die()


# --------------------------------
# BOUNCE
# --------------------------------

func bounce():

	velocity.y = -350

	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:

		velocity.x = direction * 250

	else:

		velocity.x = velocity.x * 1.5


# --------------------------------
# WATER
# --------------------------------

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


# --------------------------------
# SPACE
# --------------------------------

func enter_space():

	in_space = true


func exit_space():

	in_space = false


# --------------------------------
# BANANAS
# --------------------------------

func add_banana():

	banana_count += 1

	update_banana_ui()


func update_banana_ui():

	if banana_label:

		banana_label.text = "Bananas: " + str(banana_count)


# --------------------------------
# DAMAGE
# --------------------------------

func take_damage(amount):

	if invincible or dead:
		return

	health -= amount

	health = clamp(health, 0, max_health)

	hp_bar.value = health

	flash_red()

	if health <= 0:

		die()

		return

	invincible = true

	await get_tree().create_timer(0.5).timeout

	invincible = false


func flash_red():

	for i in range(3):

		anim.modulate = Color(1, 0.2, 0.2)

		await get_tree().create_timer(0.05).timeout

		anim.modulate = Color.WHITE

		await get_tree().create_timer(0.05).timeout


# --------------------------------
# DEATH
# --------------------------------

func die():

	if dead:
		return

	dead = true

	velocity = Vector2.ZERO

	var death_screen = get_tree().get_first_node_in_group("death_screen")

	if death_screen == null:

		print("STILL NO DEATH SCREEN (GROUP NOT FOUND)")

		return

	death_screen.show_death_screen()

	get_tree().paused = true


# --------------------------------
# VINES
# --------------------------------

func enter_vine():

	can_climb = true


func exit_vine():

	can_climb = false

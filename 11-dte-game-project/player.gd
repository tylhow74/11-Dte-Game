extends CharacterBody2D

const NORMAL_SPEED = 200.0
const WATER_SPEED = 100.0

const NORMAL_GRAVITY = 900.0
const WATER_GRAVITY = 200.0

const NORMAL_JUMP = -350.0
const WATER_JUMP = -150.0

var speed = NORMAL_SPEED
var gravity = NORMAL_GRAVITY
var jump_force = NORMAL_JUMP

var in_water = false

var max_health = 100
var health = 100

var banana_count = 0

@onready var anim = $AnimatedSprite2D
@onready var hp_bar = $ProgressBar
@onready var banana_label = $"../CanvasLayer/BananaLabel"


func _ready():
	hp_bar.min_value = 0
	hp_bar.max_value = max_health
	hp_bar.value = health
	banana_label.text = "Bananas: 0"


func add_banana():
	banana_count += 1
	banana_label.text = "Bananas: " + str(banana_count)


# ---------------- WATER FIX (CORRECT METHOD) ----------------
func check_water():
	in_water = false

	var space_state = get_world_2d().direct_space_state

	var params = PhysicsPointQueryParameters2D.new()
	params.position = global_position
	params.collide_with_areas = true
	params.collide_with_bodies = true

	var result = space_state.intersect_point(params)

	for hit in result:
		var obj = hit.collider
		if obj and obj.is_in_group("water"):
			in_water = true
			return


# ---------------- PHYSICS ----------------
func _physics_process(delta):

	check_water()

	if in_water:
		speed = WATER_SPEED
		gravity = WATER_GRAVITY
		jump_force = WATER_JUMP
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

	if Input.is_action_just_pressed("jump") and (is_on_floor() or in_water):
		velocity.y = jump_force

	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("run")
	else:
		anim.play("idle")

	move_and_slide()

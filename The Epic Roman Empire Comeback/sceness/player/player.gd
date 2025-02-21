extends CharacterBody2D

const SPEED = 230.0
const JUMP_VELOCITY = -320.0
var is_jumping = false
var is_falling = false

@onready var animation := $anim as AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
	if velocity.y > 0:
		is_falling = true
	elif is_on_floor():
		is_falling = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if !is_jumping:
			animation.play("run")
		elif is_jumping:
			animation.play("jumping")
			if is_falling:
				animation.play("falling")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")
		if is_jumping:
			animation.play("jumping")
			if is_falling:
				animation.play("falling")

	move_and_slide()

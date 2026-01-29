extends CharacterBody2D

const SPEED: float = 500.0
const JUMP_VELOCITY: float = -600.0

@onready var sprite: Sprite2D = %dog_sprite
@onready var anim: AnimationPlayer = %AnimationDog

var busy: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():	# Falling gravity
		velocity += get_gravity() * delta

	# 1. SPECIAL ANIMATIONS CHECK (Priority #1)
	if not busy:
		if Input.is_action_just_pressed("poop") and is_on_floor():
			velocity = Vector2.ZERO
			play_special_animation("dog_poop")
		if Input.is_action_just_pressed("run") and is_on_floor():
			velocity = Vector2.ZERO
			play_special_animation("dog_run")
		if Input.is_action_just_pressed("6") and is_on_floor():
			pass
		if Input.is_action_just_pressed("7") and is_on_floor():
			pass
		if Input.is_action_just_pressed("bark") and is_on_floor():
			velocity = Vector2.ZERO
			play_special_animation("dog_lines")
			return # Stop reading code here so we don't accidentally play other anims

	# 2. MOVEMENT LOGIC (Only runs if not busy)
	if not busy:
		# Jump Input
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# Left/Right Input
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# 3. MOVEMENT ANIMATIONS (Priority #2)
		if not is_on_floor():
			anim.play("dog_jump")
			# Flip sprite in air
			if velocity.x != 0:
				sprite.flip_h = velocity.x < 0
		elif velocity.x != 0:
			anim.play("dog_run")
			sprite.flip_h = velocity.x < 0
		else:
			# Only play idle if on floor AND not moving
			anim.play("dog_idle")

	move_and_slide()

func play_special_animation(animation_name: String) -> void:
	busy = true
	anim.play(animation_name)
	# Wait until this specific animation finishes
	await anim.animation_finished
	busy = false

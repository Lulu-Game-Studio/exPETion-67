extends CharacterBody2D

const SPEED: float = 100.0
const JUMP_VELOCITY: float = -200.0

@onready var sprite: Sprite2D = %dog_sprite
@onready var anim: AnimationPlayer = %AnimationDog

var busy: bool = false # Declared outside a function so it saves in the long run

func _physics_process(delta: float) -> void:
	if not is_on_floor():	# Falling gravity
		velocity += get_gravity() * delta

	# Checks if a special animation key is pressed (not busy)
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

	# MOVEMENT LOGIC (Only runs if not busy)
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

		# Movement animations (only play if there is no other animation
		if not is_on_floor():
			anim.play("dog_jump")
			# Flip sprite, works both air and ground
			if velocity.x != 0:
				sprite.flip_h = velocity.x < 0
		elif velocity.x != 0:
			anim.play("dog_run")
			sprite.flip_h = velocity.x < 0
		else:
			anim.play("dog_idle")

	move_and_slide()

func play_special_animation(animation_name: String) -> void: # Funtion to stop other animations from stepping on special animations (idle fix)
	busy = true
	anim.play(animation_name)
	# Wait until this specific animation finishes
	await anim.animation_finished # It waits for the animation to end so you can play th game
	busy = false

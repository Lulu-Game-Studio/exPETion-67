extends CharacterBody2D


const SPEED: float  = 500.0
const JUMP_VELOCITY: float = -600.0

@onready var sprite: Sprite2D = %dog_sprite
@onready var anim: AnimationPlayer = %AnimationDog


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
# Basic movement
	if is_on_floor():
		if velocity.x != 0:
			anim.play("dog_run")
			sprite.flip_h = velocity.x < 0
		else:
			anim.play("dog_idle")
	else:
		anim.play("dog_jump")
		if velocity.x != 0:
			sprite.flip_h = velocity.x < 0
	
	# Other keys animations
	if Input.is_action_just_pressed("poop") and is_on_floor():
		anim.play("dog_poop")


	move_and_slide()

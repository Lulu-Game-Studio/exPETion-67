extends CharacterBody2D

const SPEED: float = 100.0
const SPEED_RUNNING: float = 250.0
const JUMP_VELOCITY: float = -300.0

@onready var sprite: Sprite2D = %dog_sprite
@onready var anim: AnimationPlayer = %AnimationDog

# Boolean to check if there is another animation queuing to play besides movement ones
var busy: bool = false 

func _physics_process(delta: float) -> void:
	if not is_on_floor():	
		velocity += get_gravity() * delta
	# Left/Right Input
	var direction := Input.get_axis("left", "right")

	# Checks if a special animation key is pressed (not busy)
	if not busy:
		if Input.is_action_just_pressed("poop") and is_on_floor():
			velocity = Vector2.ZERO
			play_special_animation("dog_poop")
		# Next two if's passes because there isn't neither the sprite nor the animation to do that
		if Input.is_action_just_pressed("6") and is_on_floor():
			pass
		if Input.is_action_just_pressed("7") and is_on_floor():
			pass
			
		if Input.is_action_just_pressed("bark") and is_on_floor():
			velocity = Vector2.ZERO
			play_special_animation("dog_lines")

	# Movement Logic (Only runs if not busy, separed from the upper if for more organization)
	if not busy:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# Local variable to know if it's running or not more below
		var actual_speed = SPEED
		# Keeps working until unpressed
		if Input.is_action_pressed("run"):
			actual_speed = SPEED_RUNNING
		
		# Flipping sprites, works with jumping too
		if direction:
			velocity.x = direction * SPEED
			if velocity.x < 0:
				sprite.flip_h = true
			elif velocity.x > 0:
				sprite.flip_h = false
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		# It's over the jumping animation so it still runs while jumping
		velocity.x = actual_speed * direction
		# Movement animations (only play if there is no other animation)
		if not is_on_floor():
			# y is reversed in godot
			if velocity.y < 0:
				anim.play("dog_jump")
			else:
				anim.play("dog_fall")
			# How to apply the ground animation?
			
		## Movement animation logic, if the local variable is equal to the absolute quantity 
		## (the absolute is necessary so left-negative is also covered), plays its own animation, else it's idle
		elif velocity.x != 0:
			if actual_speed == abs(SPEED):
				anim.play("dog_walk")
			elif actual_speed == abs(SPEED_RUNNING):
				anim.play("dog_run")
		else:
			anim.play("dog_idle")
	else:
		anim.play("dog_jump")
		if velocity.x != 0:
			sprite.flip_h = velocity.x < 0
			
	# Other keys animations
	if Input.is_action_just_pressed("poop") and is_on_floor():
		anim.play("dog_poop")
	if Input.is_action_just_pressed("bark"): # Bark with lines, change when enemies exist
		anim.play("dog_lines")
	if Input.is_action_just_pressed("bark"): # Bark WITHOUT lines, no need to change
		anim.play("dog_withoutlines")
	if Input.is_action_just_pressed("run"): # Need a change, quick fix but not looped while shift
		anim.play("dog_run")
	
	


	move_and_slide()

## Function to stop the character from being able to move (busy == true), then starts the next animation
## (the one pressed), which changes its direction to ZERO (0, 0) so it doesn't move itself while animating,
## ends the animation with the 'await' command and turns busy false so you can play the game again.
func play_special_animation(animation_name: String) -> void: 
	busy = true
	anim.play(animation_name)
	# It waits for the animation to end so you can play the game
	await anim.animation_finished 
	busy = false

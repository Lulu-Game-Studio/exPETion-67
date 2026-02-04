extends CharacterBody2D

const SPEED: float = 100.0
const SPEED_RUNNING: float = 250.0
const JUMP_VELOCITY: float = -300.0

## Variables are separated to organize their use

# Poopbar increasing and starting values
var poopValue: float = 0.0
const poopIncrease: int = 15

# Boolean to work with the key
var haveKey: bool = false

# Create a null poop checkpoint so it doesn't create an unlimited amount of poops
var poopPoint: RigidBody2D = null

# Collects secret poops throughout the game
var poopCoins: int = 0

@onready var poopBar : ProgressBar = $PoopBar/poopBar
@onready var sprite: Sprite2D = %dog_sprite
@onready var anim: AnimationPlayer = %AnimationDog

# It needs to be preloaded so when the dog poops it can be created and saved as a checkpoint
const POOP_SCENE = preload("res://scenes/checkpoint_poop.tscn")
# Boolean to check if there is another animation queuing to play besides movement ones
var busy: bool = false 
# Augmented HP due to attack issues
var HP: int = 6

func _physics_process(delta: float) -> void:
	#checking if the poopbar is filled or not
	if poopValue < 100:
		#if not filled increase with the const
		poopValue+= poopIncrease * delta
		poopValue = clamp(poopValue,0,100)
	#if there is a poopBar constantly upload it with news values
	if poopBar:
		poopBar.value= poopValue

	if not is_on_floor():	
		velocity += get_gravity() * delta
	# Left/Right Input
	var direction := Input.get_axis("left", "right")

	# Checks if a special animation key is pressed (not busy)
	if not busy:
		if Input.is_action_just_pressed("poop") and is_on_floor() and poopBar.value == 100:
			poopBar.value = 0
			velocity = Vector2.ZERO
			play_special_animation("dog_poop")
			
		# Next two if's passes because there isn't neither the sprite nor the animation to do that
		if Input.is_action_just_pressed("6") and is_on_floor():
			play_special_animation("dog_six")

		if Input.is_action_just_pressed("bark") and is_on_floor():
			velocity = Vector2.ZERO
			play_special_animation("dog_lines")
			
		if Input.is_action_just_pressed("reset") and is_on_floor():
			die()

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



	# Other keys animations
	if Input.is_action_just_pressed("poop") and is_on_floor():
		anim.play("dog_poop")
		poopValue=0
	if Input.is_action_just_pressed("bark"): # Bark with lines, change when enemies exist
		anim.play("dog_lines")
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
	if animation_name == "dog_poop":
		spawn_poop()
	busy = false

# Called from Doberman's script
func take_dmg(dmg: int) -> void:
	HP -= dmg
	print(str(HP))
	if HP <= 0:
		die() 
	
func spawn_poop() -> void:
	# First time the checkpoint is generated
	if poopPoint == null:
		# Instantiate the checkpoint poop to create it inside the game's memory, preloading is not enough
		poopPoint = POOP_SCENE.instantiate()
		# could be owner instead of get_parent() too, this creates the previously instantiated poop
		get_parent().add_child(poopPoint)
	# Needed in case it falls to the infinity, it doesn't bug
	poopPoint.linear_velocity = Vector2(0, 0)
	# Gives the dog's position, depending if it's flipped or not, the X axis is slightly tweaked
	# so it looks like the poop isn't spawning from him belly or smth, can be tweaked easily
	if sprite.flip_h:
		poopPoint.global_position = global_position + Vector2(30, 20)
	else:
		poopPoint.global_position = global_position - Vector2(30, -20)
	


func die() -> void:
	if poopPoint != null:
		# Moves the dog to the poop's position
		global_position = poopPoint.global_position +  Vector2(0, -20)
		# If it falls moving or falling, it resets the velocity
		velocity = Vector2(0, 0)
		# Refills HP bar
		HP = 6
	else:
		# If there aren't any checkpoints, this resets the level
		get_tree().reload_current_scene()


func getCoins() -> void:
	poopCoins += 1
	# Temporal print to check if it stacks well
	print("You currently have: " + str(poopCoins) + " secret poops.")

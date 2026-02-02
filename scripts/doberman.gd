extends CharacterBody2D


var speed = 0.0


@onready var attack_timer: Timer = $Attack_timer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite
@onready var attack_area: Area2D = %Attack_area

var busy: bool = false
# Dog, it's used to reference to its name or group
var target_player: Node2D = null

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not speed and not busy:
		# Currently doesn't work properly, runs while idle but this if works once
		if animation_player.current_animation != "doberman_idle":
			animation_player.play("doberman_idle")
	else:
		if animation_player.current_animation != "doberman_walk" and speed:
			animation_player.play("doberman_walk")
	move_and_slide()
	
func _on_dog_detection_area_body_entered(body: Node2D) -> void:
	speed = 20.0
	if body.name == "dog":
		busy = true
		# Here's where the dog is declared for the entire script, once it enters the zone
		target_player = body
		# Sign only gives a direction (-1, 1)
		var direction = sign(target_player.global_position.x - global_position.x)
		velocity.x = direction * speed
		
		# Classic flipping sprite
		if direction:
			if direction > 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
	

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "dog":
		speed = 0
		velocity.x = 0
		# So it doesn't start attacking from just entering the zone, would be a safe hit
		animation_player.play("doberman_idle")
		# Doberman's attacks are restricted by this timer
		attack_timer.start()


func _on_attack_timer_timeout() -> void:
	# Loops the bark animation while the dog's inside the attack radius
	animation_player.play("doberman_attack")
	
	## If it already recognized the player (target_player gets its value during the detection area),
	## it generates a list of all the bodies colliding.
	if target_player != null:
		var bodyList = attack_area.get_overlapping_bodies()
		print(bodyList)
		
		# if target_player (the dog) is in there, does damage
		if target_player in bodyList:
			target_player.take_dmg(1)
			

# The Doberman idles if the dog exits its detection area
func _on_dog_detection_area_body_exited(body: Node2D) -> void:
	# Could have used body.name == "dog", same effect
	if body.is_in_group("player"):
		velocity.x = 0
		speed = 0.0
		animation_player.play("doberman_idle")

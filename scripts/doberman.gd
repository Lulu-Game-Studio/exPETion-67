extends CharacterBody2D

var speed = 35.0 # Constant base speed

var target_player: Node2D = null
var busy: bool = false

@onready var attack_timer: Timer = $Attack_timer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite
@onready var attack_area: Area2D = %Attack_area

func _physics_process(delta: float) -> void:
	# 1. Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Logic of Movement
	if target_player and not busy:
		var direction = sign(target_player.global_position.x - global_position.x)
		velocity.x = direction * speed
		
		# Sprite orientation
		sprite.flip_h = direction < 0
		
		if animation_player.current_animation != "doberman_walk":
			animation_player.play("doberman_walk")
	else:
		# If there is no one around or we are attacking, we gradually stop.
		velocity.x = move_toward(velocity.x, 0, speed)
		# We only set it to idle if we're not in the middle of an attack animation.
		if not busy and animation_player.current_animation != "doberman_idle":
			animation_player.play("doberman_idle")

	move_and_slide()

# --- Signals ---

func _on_dog_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "dog":
		target_player = body

func _on_dog_detection_area_body_exited(body: Node2D) -> void:
	if body == target_player:
		target_player = null # When you lose sight of it, stop chasing it

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body == target_player:
		busy = true # It stops to attack
		animation_player.play("doberman_idle")
		attack_timer.start()

func _on_attack_timer_timeout() -> void:
	if target_player:
		animation_player.play("doberman_attack")
		
		# Damage check
		var bodyList = attack_area.get_overlapping_bodies()
		if target_player in bodyList:
			target_player.take_dmg(1)
		
		# If the player is no longer in the attacking area, we are no longer occupied
		var bodies_en_ataque = attack_area.get_overlapping_bodies()
		if not target_player in bodies_en_ataque:
			busy = false
			attack_timer.stop()

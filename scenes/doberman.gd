extends CharacterBody2D


var speed = 20.0


@onready var attack_timer: Timer = $Attack_timer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sprite: Sprite2D = %Sprite
@onready var attack_area: Area2D = %Attack_area

var busy: bool = false
var target_player: Node2D = null

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
func _on_dog_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "dog":
		target_player = body
		var direction = sign(target_player.global_position.x - global_position.x)
		velocity.x = direction * speed
		animation_player.play("doberman_walk")
		
		
		if direction:
			if direction > 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
	

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "dog":
		speed = 0
		velocity.x = 0
		attack_timer.start()
		


func _on_attack_timer_timeout() -> void:
	animation_player.play("doberman_attack")
	
	if animation_player.is_playing():
		var bodyList = attack_area.get_overlapping_bodies()
		print(bodyList)
		# Tried 2 methods, neither of those work, need fix, this is the damage output
		# TRY DOG WITH BODYLIST PRINT
		#if "dog" in bodyList:
		#	print("Ouch")
		#else:
		#	print("Nada")

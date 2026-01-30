extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MOVEMENTS = ["doberman_idle", "doberman_walk", "doberman_attack"]

@onready var animation_player: AnimationPlayer = %AnimationPlayer
var busy: bool = false


func _on_dog_detection_area_body_entered(body: Node2D) -> void:
	while not busy:
		animation_player.play("doberman_idle")
	if body.name == "dog":
		busy = true
		var an = MOVEMENTS.pick_random()
		if an == "doberman_idle":
			animation_player.play("doberman_idle")
		elif an == "doberman_walk":
			animation_player.play("doberman_idle")
		else:
			animation_player.play("doberman_idle")

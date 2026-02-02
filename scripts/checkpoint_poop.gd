extends RigidBody2D

# Checkpoint saves player's current position so when it dies, 
# it respawns in the last checkpoint it touched
var checkpoint: Vector2

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		checkpoint = body.global_position

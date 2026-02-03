extends Area2D

var objective: Node2D = null
var catched: bool = false

@export var head_height: float = 5

var animation_dog: AnimationPlayer = null


func _on_body_entered(body):
	# Verify if the body is the player 
	if body.is_in_group("player"):
		objective = body
		catched = true
		
		# Disable collisions after being catched
		$CollisionShape2D.set_deferred("disabled", true)
		set_deferred("monitoring", false)
		
	animation_dog = body.get_node("AnimationDog")
	
func _process(_delta):
	if catched and objective:
		global_position.x = objective.global_position.x
		global_position.y = objective.global_position.y - head_height
	
	if animation_dog != null:
		if Input.is_action_just_pressed("6"):
			hide()
			await animation_dog.animation_finished
			show()

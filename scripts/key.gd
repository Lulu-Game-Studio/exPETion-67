extends Area2D

var objective: Node2D = null
var catched: bool = false

@export var head_height: float = 5

func _ready():
	#Connect the signal
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body):
	# Verify if the body is the player 
	if body.is_in_group("player"):
		objective = body
		catched = true
		
		# Disable collisions after being catched
		$CollisionShape2D.set_deferred("disabled", true)
		set_deferred("monitoring", false)
	
func _process(_delta):
	if catched and objective:
		global_position.x = objective.global_position.x
		global_position.y = objective.global_position.y - head_height

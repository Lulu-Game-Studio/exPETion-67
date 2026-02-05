extends Area2D

@onready var anims = $AnimationPlayer

func _process(delta: float):
	anims.play("car")


func _on_body_entered(body: Node2D):
	body.die()

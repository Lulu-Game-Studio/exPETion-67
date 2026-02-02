extends Area2D

var velocidad: float = 90
var objetivo: Node2D= null


func _on_body_entered(body):
	objetivo=body

func _process(delta):
	if objetivo:
		var direccion = (objetivo.global_position - global_position).normalized()
		global_position += direccion * velocidad * delta

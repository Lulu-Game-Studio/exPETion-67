extends Area2D

@onready var anims = %AnimationPlayer

func _on_body_entered(body: Node2D):
	
	if body.haveKey == true:
		open_house()
		
func open_house():
	#Make open animation
	anims.play("jaus")
		
	await anims.animation_finished
	#goBacktoMap
	get_tree().change_scene_to_file("res://scenes/maps/Map.tscn")
		
		
		#locksound
		

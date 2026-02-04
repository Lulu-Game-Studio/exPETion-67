extends Area2D

@export var level_number : int = 1
@onready var anims = %AnimationPlayer

func _on_body_entered(body: Node2D):
	
	if body.haveKey == true:
		open_house(body)
		
func open_house(dog):
	#Make open animation
	anims.play("jaus")
		
	await anims.animation_finished
	
	Global.completed_level(level_number, dog.poopCoins)
	#goBacktoMap
	get_tree().change_scene_to_file("res://scenes/maps/Map.tscn")
		
		
		#locksound
		

extends Area2D

@export var level_number : int = 1
@onready var anims = %AnimationPlayer

var level_cleared : bool = false

func _on_body_entered(body: Node2D):
	if body.haveKey == true and not level_cleared:
		level_cleared = true 
		open_house(body)
		
func open_house(dog):
	anims.play("jaus")
		
	await anims.animation_finished
	
	if not is_inside_tree():
		return

	Global.completed_level(level_number, dog.poopCoins)
	if level_number == 7:
		get_tree().change_scene_to_file()
	get_tree().change_scene_to_file("res://scenes/maps/Map.tscn")

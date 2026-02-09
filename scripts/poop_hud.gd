extends Control

@onready var label = $Sprite2D/Label

func _process(delta: float):
	var dog = get_tree().get_first_node_in_group("player")
	var dogPoop = dog.poopCoins
	label.text =  str(dogPoop)+"/3"

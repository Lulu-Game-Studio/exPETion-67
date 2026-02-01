extends Area2D

@onready var dog = get_tree().get_first_node_in_group("Player")
var haveKey = dog.haveKey

func _on_body_entered(body: Node2D):
	if haveKey == true:
		#LEVELEND
		#Makeopenanimation
		Animation
		#goBacktoMap
		
	#else:
		#locksound
		

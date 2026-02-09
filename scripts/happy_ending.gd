extends Node2D


func _on_control_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/Map.tscn")

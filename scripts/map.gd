extends Node2D
var maxLevelReached = 1
var generalPoops = 0



func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://scenes/maps/Level01.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/Level02.tscn")

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/Level03.tscn")

func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/Level04.tscn")

func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/level05.tscn")

func _on_level_6_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/level06.tscn")

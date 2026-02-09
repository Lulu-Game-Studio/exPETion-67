extends Node2D
func _ready():
	upload_map()

func upload_map():
	conf_bot(1, $"Level 1", $Label)
	conf_bot(2, $"Level 2", $Label2)
	conf_bot(3, $"Level 3", $Label3)
	conf_bot(4, $"Level 4", $Label4)
	conf_bot(5, $"Level 5", $Label5)
	conf_bot(6, $"Level 6", $Label6)
#	conf_bot(7, $Level7Button, $Label7)
func _process(delta: float):
	if Global.totalPoops == 18:
		get_tree().change_scene_to_file("res://scenes/maps/PoopMap.tscn")

func conf_bot(levelNum, button, Labels):
	var info = Global.levels[levelNum]
	
	button.disabled = !info.unlocked
	Labels.text = str(info.items) + "/3"
	
	if levelNum == 7 and button.disabled:
		Labels.text = "Search all the secrets poops"

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


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/maps/controls.tscn")

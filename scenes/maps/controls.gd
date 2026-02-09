extends Node2D
func _input(event):
	# Detecta si se ha pulsado cualquier tecla o botón del ratón
	if event is InputEventKey or event is InputEventMouseButton:
		# Solo si la tecla fue presionada (para evitar que se active al soltarla)
		if event.pressed:
			get_tree().change_scene_to_file("res://scenes/maps/Map.tscn")

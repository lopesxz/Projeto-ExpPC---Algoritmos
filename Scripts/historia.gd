extends Control

func _on_estou_pronto_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Fases/Tutorial_1.tscn")

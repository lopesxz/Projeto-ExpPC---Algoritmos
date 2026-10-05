extends Control

func _on_botao_jogar_pressed() -> void:
	# Vai direto para a Fase 0 (Modo Carreira / Tutorial)
	get_tree().change_scene_to_file("res://Cenas/Fases/Fase_00.tscn")

func _on_botao_fases_pressed() -> void:
	# Abre a tela de seleção de fases
	get_tree().change_scene_to_file("res://Cenas/Menu/painel_fases.tscn")

func _on_botao_sair_pressed() -> void:
	# Fecha o jogo completamente
	get_tree().quit()

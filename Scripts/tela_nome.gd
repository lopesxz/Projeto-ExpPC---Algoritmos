extends Node2D

const CENA_MENU = "res://Cenas/Menu/menu_principal.tscn"

func _on_botao_confirmar_pressed() -> void:
	var input_nome = $LineEdit.text.strip_edges()
	
	# Verifica se a caixa de texto está vazia
	if input_nome == "":
		# Mostra o Label de aviso para a criança preencher
		$AvisoLabel.visible = true
		await get_tree().create_timer(3.0).timeout  
		$AvisoLabel.visible = false
	else:
		# Esconde o aviso caso estivesse visível de uma tentativa anterior
		$AvisoLabel.visible = false
		
		# Guarda o nome no script global (GerenciadorLog)
		GerenciadorLog.definir_nome_crianca(input_nome)
		
		# Avança para o Menu Principal
		get_tree().change_scene_to_file("res://Cenas/Menu/menu_principal.tscn")

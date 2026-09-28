extends Node

var bloco_selecionado = null

# Guarda o número da fase atual
var numero_fase_atual: int = 4
var nome_fase_atual: String = "Fase_04"

# Função para avançar automaticamente para a fase seguinte
func proxima_fase() -> void:
	numero_fase_atual += 1
	nome_fase_atual = "Fase_%02d" % numero_fase_atual
	var caminho = "res://Cenas/Fases/%s.tscn" % nome_fase_atual
	
	if ResourceLoader.exists(caminho):
		get_tree().change_scene_to_file(caminho)
	else:
		print("Fim das fases! A voltar ao menu principal...")
		get_tree().change_scene_to_file("res://Cenas/menu_principal.tscn")

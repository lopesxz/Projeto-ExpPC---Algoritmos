extends Node

const CAMINHO_LOG = "user://dados_jogada.json"
var fase_atual = ""


var dados_sessao = {
	"nome_crianca": "Aluno", 
	"mac_address": "simulado_pc_01", 
	"id_jogada": 1, 
	"tempo_total_segundos": 0.0,
	"quantidade_tentativas": 0,
	"historico_tentativas": []
}

var tentativa_atual = {
	"fase": "",
	"tentativa_numero": 1,
	"tempo_parcial_segundos": 0.0,
	"metricas_botoes": {
		"apagar_tudo": 0,
		"apagar_1": 0,
		"uso_setas": 0
	},
	"lista_blocos_intermediarios": []
}

func _ready() -> void:
	randomize()
	dados_sessao.id_jogada = randi() % 90000 + 10000
	
	# Descobre o nome da fase atual a partir do ficheiro da cena
	fase_atual = scene_file_path.get_file().get_basename()
	tentativa_atual["fase"] = fase_atual
	
	# Começa a contar o tempo da primeira tentativa assim que o jogo/fase abre!
	iniciar_cronometro()

func atualizar_fase_atual() -> void:
	var nome_fase = scene_file_path.get_file().get_basename()
	fase_atual = nome_fase
	tentativa_atual["fase"] = nome_fase

func iniciar_cronometro() -> void:
	tempo_inicio_tentativa = Time.get_ticks_msec()
	cronometrando = true

func parar_cronometro() -> void:
	if cronometrando:
		var tempo_atual_ms = Time.get_ticks_msec()
		tempo_decorrido_acumulado = float(tempo_atual_ms - tempo_inicio_tentativa) / 1000.0
		cronometrando = false

func reiniciar_e_continuar_cronometro() -> void:
	iniciar_cronometro()

func definir_lista_blocos_tentativa(lista: Array) -> void:
	tentativa_atual.lista_blocos_intermediarios = lista.duplicate()
	
func registrar_clique_botao(nome_botao: String) -> void:
	match nome_botao.to_lower():
		"apagar_tudo", "apagar_todos":
			tentativa_atual.metricas_botoes.apagar_tudo += 1
		"apagar_1", "apagar_um":
			tentativa_atual.metricas_botoes.apagar_1 += 1
		"cima", "baixo":
			tentativa_atual.metricas_botoes.uso_setas += 1
			

func definir_nome_crianca(nome: String) -> void:
	if nome.strip_edges() != "":
		dados_sessao.nome_crianca = nome.strip_edges()
	else:
		dados_sessao.nome_crianca = "Não identificado"
		
func finalizar_tentativa(sucesso: bool) -> void:
	# Atualiza a fase caso tenha mudado
	atualizar_fase_atual()
	
	# Para o cronômetro no exato momento em que a execução é disparada/finalizada
	parar_cronometro()
	
	tentativa_atual.tempo_parcial_segundos = snapped(tempo_decorrido_acumulado, 0.01) # Arredonda para 2 casas decimais
	dados_sessao.quantidade_tentativas += 1
	dados_sessao.tempo_total_segundos = snapped(dados_sessao.tempo_total_segundos + tentativa_atual.tempo_parcial_segundos, 0.01)
	
	# Salva no histórico
	dados_sessao.historico_tentativas.append(tentativa_atual.duplicate())
	salvar_em_disco()
	
	# Prepara a próxima tentativa (o cronômetro só reiniciará quando o aluno clicar em Reiniciar)
	tentativa_atual = {
		"fase": fase_atual,
		"tentativa_numero": tentativa_atual.tentativa_numero + 1,
		"tempo_parcial_segundos": 0.0,
		"metricas_botoes": {
			"apagar_tudo": 0,
			"apagar_1": 0,
			"uso_setas": 0
		},
		"lista_blocos_intermediarios": []
	}
	tempo_decorrido_acumulado = 0.0

func salvar_em_disco() -> void:
	var arquivo = FileAccess.open(CAMINHO_LOG, FileAccess.WRITE)
	if arquivo:
		var json_texto = JSON.stringify(dados_sessao, "\t")
		arquivo.store_string(json_texto)
		arquivo.close()
		print("Log atualizado e salvo em disco com sucesso!")

# Variáveis internas para gerenciar o tempo de raciocínio
var tempo_inicio_tentativa: int = 0
var tempo_decorrido_acumulado: float = 0.0
var cronometrando: bool = false

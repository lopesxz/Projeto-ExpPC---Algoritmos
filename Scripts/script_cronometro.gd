extends CanvasLayer
var tempo_segundos = 0.0
var rodando = true

func _process(delta: float) -> void:
	if rodando:
		tempo_segundos += delta
		
		var minutos = int(tempo_segundos) / 60
		var segundos = int(tempo_segundos) % 60
		var texto_tempo = "Tempo: %02d:%02d" % [minutos, segundos]
		
		var label_tempo = find_child("TempoTotalLabel", true, false)
		if label_tempo:
			label_tempo.text = texto_tempo

func parar() -> void:
	rodando = false

func obter_tempo_atual() -> float:
	return tempo_segundos

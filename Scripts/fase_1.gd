extends Node2D

@onready var area_montagem: ColorRect = $InterfaceBlocos/Control/AreaMontagem
@onready var avancar: Control = $InterfaceBlocos/Control/AreaEstoque/Avancar

func _ready() -> void:
	for i in range(14):
		area_montagem.adicionar_bloco(avancar.duplicate())

class_name PAGINA_PACKS
extends VBoxContainer

signal abrir_tudo(packs:Dictionary)
signal abrir_um_booster(packs:Dictionary)

@onready var centralizador_booster_abrivel:CenterContainer = $CentralizadorBoosterAbrivel
@onready var controlador_de_booster_disponivel:HBoxContainer = $OrganizadorDeBoosters/GeradorDeScroll/ControladorDeBoosterDisponivel

@export var borda_booster_cena:PackedScene

var packs_disponiveis:Dictionary = {}
var booster_em_destaque:BORDA_BOOSTER

func _ready():
	abrir_um_booster.connect(instanciar_popup_de_abertura_de_booster)
	abrir_tudo.connect(instanciar_popup_de_abertura_de_booster)

func atualizar_informacoes(AccountInfo:Dictionary) -> void:
	if AccountInfo.is_empty():
		return
	
	packs_disponiveis["packs"] = AccountInfo["packs"]
	if packs_disponiveis.is_empty():
		return
	
	if controlador_de_booster_disponivel.get_child_count() != 0:
		booster_em_destaque = controlador_de_booster_disponivel.get_child(0)
		controlador_de_booster_disponivel.remove_child(booster_em_destaque)
		centralizador_booster_abrivel.add_child(booster_em_destaque)
		booster_em_destaque.custom_minimum_size = Vector2(500,710)
		booster_em_destaque.size = booster_em_destaque.custom_minimum_size
		return
	
	for edicao in packs_disponiveis["packs"]:
		for packs in range(packs_disponiveis["packs"][edicao]["quantidade"]):
			var cena_instancia = borda_booster_cena.instantiate()
			cena_instancia.edicao = edicao
			controlador_de_booster_disponivel.add_child(cena_instancia)
			cena_instancia.booster_selecionado.connect(quando_novo_booster_selecionado)
			
	if controlador_de_booster_disponivel.get_child_count() != 0:
		booster_em_destaque = controlador_de_booster_disponivel.get_child(0)
		controlador_de_booster_disponivel.remove_child(booster_em_destaque)
		centralizador_booster_abrivel.add_child(booster_em_destaque)
		booster_em_destaque.custom_minimum_size = Vector2(500,710)
		booster_em_destaque.size = booster_em_destaque.custom_minimum_size
		
		for booster:Control in controlador_de_booster_disponivel.get_children():
			booster.custom_minimum_size = Vector2(100,142)
			booster.size = booster.custom_minimum_size

func quando_botao_abrir_tudo_pressionado():
	if packs_disponiveis.is_empty():
		return
	
	abrir_tudo.emit(packs_disponiveis["packs"])
	for filho in controlador_de_booster_disponivel.get_children():
		filho.queue_free()
	if centralizador_booster_abrivel.get_child_count() != 0:
		for filho in centralizador_booster_abrivel.get_children():
			filho.queue_free()
	packs_disponiveis.clear()
	atualizar_informacoes(packs_disponiveis)

func quando_novo_booster_selecionado(Booster:BORDA_BOOSTER, colecao:String) -> void:
	if Booster == booster_em_destaque:
		var packs:Dictionary = {Booster.edicao: {"quantidade": 1}}
		abrir_um_booster.emit(packs)
		packs_disponiveis["packs"][Booster.edicao]["quantidade"] -= 1
		booster_em_destaque.queue_free()
		booster_em_destaque = null
		atualizar_informacoes(packs_disponiveis)
		return
	
	#move o booster do centro da tela de volta para a lista de bosters selecionaveis
	centralizador_booster_abrivel.remove_child(booster_em_destaque)
	controlador_de_booster_disponivel.add_child(booster_em_destaque)
	booster_em_destaque.custom_minimum_size = Vector2(100,142)
	booster_em_destaque.size = booster_em_destaque.custom_minimum_size
	booster_em_destaque = Booster

	#move o boster clicado para o centro da tela
	controlador_de_booster_disponivel.remove_child(booster_em_destaque)
	centralizador_booster_abrivel.add_child(booster_em_destaque)
	booster_em_destaque.custom_minimum_size = Vector2(500,710)
	booster_em_destaque.size = booster_em_destaque.custom_minimum_size

func instanciar_popup_de_abertura_de_booster(packs:Dictionary) -> void:
	var popup_instancia:BOOSTER_POPUP = CONS.BOOSTER_POPUP_CENA.instantiate()
	get_tree().root.add_child(popup_instancia)
	popup_instancia.solcitar_abertura_de_booster_ao_servidor(packs)
	get_tree().paused = true

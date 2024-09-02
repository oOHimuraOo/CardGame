class_name MAQUINA_DE_COMPORTAMENTO
extends Node

@onready var mao:Node = $Mao
@onready var entrar:Node = $Entrar
@onready var sair:Node = $Sair
@onready var inicio_da_manutencao:Node = $InicioDaManutencao
@onready var final_da_manutencao:Node = $FinalDaManutencao
@onready var inicio_do_combate:Node = $InicioDoCombate
@onready var final_do_combate:Node = $FinalDoCombate
@onready var atacar:Node = $Atacar
@onready var bloquear:Node = $Bloquear
@onready var morrer:Node = $Morrer


var carta: CARTA_BASE
var comportamento_ativo: COMPORTAMENTO_BASE

func alocar_comportamento(comportamento: COMPORTAMENTO_BASE) -> void:
	match comportamento.name:
		"Provocar":
			bloquear.add_child(comportamento)
		"Renascer":
			morrer.add_child(comportamento)
		"EscudoDivino":
			bloquear.add_child(comportamento)
		"Veneno":
			atacar.add_child(comportamento)
		"ToqueMortifero":
			bloquear.add_child(comportamento)
		"VinculoComAVida":
			atacar.add_child(comportamento)
		"Voar":
			atacar.add_child(comportamento)
		"Impeto":
			atacar.add_child(comportamento)
		"Iniciativa":
			atacar.add_child(comportamento)
		"Atropelar":
			atacar.add_child(comportamento)
		"Lampejo":
			atacar.add_child(comportamento)
		"ResistenciaAMagia":
			bloquear.add_child(comportamento)
		"Especial":
			pass

func verificar_maquina_de_comportamento() -> void:
	for gatilho in get_children():
		for comportamento in gatilho.get_children():
			if comportamento is COMPORTAMENTO_BASE:
				comportamento.MDC = self
				carta = find_parent("CartaModel")
				comportamento.donoDoComportamento = carta
				continue
			else:
				push_error(comportamento.name," não é um comportamento valido")
				comportamento.queue_free()

func _process(delta):
	if comportamento_ativo:
		comportamento_ativo.no_processamento(delta)

func _physics_process(delta):
	if comportamento_ativo:
		comportamento_ativo.no_processamento_de_fisica(delta)

func _input(event):
	if comportamento_ativo:
		comportamento_ativo.no_input(event)

func nova_rodada() -> void:
	for gatilho in get_children():
		for comportamento in gatilho.get_children():
			if comportamento.resetavel_por_combate or comportamento.resetavel_por_rodada:
				comportamento.Ativado = false
				comportamento.ativacoes = 0

func mudar_comportamento_ativo(gatilho: String, informacoes: Dictionary = {}) -> void:
	if find_child(gatilho).get_child_count() == 0:
		return
	
	var novo_comportamento: String
	for comportamento: COMPORTAMENTO_BASE in find_child(gatilho).get_children():
		if !comportamento.ativado && comportamento != comportamento_ativo:
			novo_comportamento = comportamento.nome
	
	comportamento_ativo.ao_sair_do_comportamento()
	comportamento_ativo = find_child(gatilho).find_child(novo_comportamento)
	comportamento_ativo.ao_entrar_no_comportamento(informacoes)

class_name COMPORTAMENTO_BASE
extends Node

signal comportamento_iniciado(Nome_comportamento)
signal comportamento_finalizado(Nome_comportamento)

var MDC: MAQUINA_DE_COMPORTAMENTO 
var donoDoComportamento: CARTA_BASE

var nome:String
var gatilho: String

var Ativado: bool = false

var resetavel_por_combate: bool = false

var resetavel_por_rodada: bool = true
var limitador_de_ativacoes: int = 3
var ativacoes: int = 0

func ao_entrar_no_comportamento(_informacoes: Dictionary = {}) -> void:
	if resetavel_por_combate:
		Ativado = true
	elif resetavel_por_rodada:
		if limitador_de_ativacoes >= ativacoes:
			ativacoes += 1
		else:
			Ativado = true
	else:
		Ativado = true
	
	comportamento_iniciado.emit(nome)
	set_process(true)
	set_physics_process(true)
	set_process_input(true)

func no_processamento(_delta) -> void:
	pass

func no_processamento_de_fisica(_delta) -> void:
	pass

func no_input(_event) -> void:
	pass

func ao_sair_do_comportamento() -> void:
	comportamento_finalizado.emit(nome)
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

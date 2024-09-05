class_name DECKLIST
extends Node

signal nome_encontrado(nome:String)
signal raca_encontrada(raca:String)
signal deck_list_carregada()

var decklist:Dictionary = {}

func gerar_decklist(deck:Dictionary) -> void:
	decklist.clear()
	decklist[deck["nome"]] = {}
	decklist[deck["nome"]]["raca"] = deck["raca"]
	decklist[deck["nome"]]["cartas"] = {}
	
	nome_encontrado.emit(deck["nome"])
	raca_encontrada.emit(deck["raca"])
	
	for edicao in deck["cartas"]:
		decklist[deck["nome"]]["cartas"][edicao] = []
		for idx in deck["cartas"][edicao]:
			decklist[deck["nome"]]["cartas"][edicao].append(int(idx))
	
	deck_list_carregada.emit()

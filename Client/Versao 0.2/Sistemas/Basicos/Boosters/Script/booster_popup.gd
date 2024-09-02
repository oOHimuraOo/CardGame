class_name BOOSTER_POPUP
extends Control


@onready var armazenador_de_cartas:HBoxContainer = $BordaPlanoDeFundo/Marginalizador/OrganizadorDeMiolo/GeradorDeScroll/ArmazenadorDeCartas


func solcitar_abertura_de_booster_ao_servidor(boosters:Dictionary) -> void:
	SERVER.enviando.solicitar_abertura_de_booster(boosters)

#func abrir_booster(boosters:Dictionary) -> void:
	#var carta_tirada: Dictionary = {}
	#for colecao in boosters:
		#carta_tirada[colecao] = {}
		#for x in range(boosters[colecao]["quantidade"]):
			#for y in range(5):
				#var carta_instancia:CARTA_BASE = CONS.CARTA_CENA.instantiate()
				#armazenador_de_cartas.add_child(carta_instancia)
				#var index:int = randi_range(0,DATA.CardInfo[colecao].size() - 1)
				#carta_instancia.carregar_informacoes_da_carta(index, colecao)
				#if carta_tirada[colecao].has(str(index)):
					#carta_tirada[colecao][str(index)]["quantidade"] += 1
				#else:
					#carta_tirada[colecao][str(index)] = {"quantidade": 1}
	#
	#adicionar_cartas_a_colecao(carta_tirada)

func instanciar_cartas(cartas:Dictionary) -> void:
	for edicao in cartas:
		var index_lista:Array = []
		for carta in cartas[edicao]:
			for x in range(cartas[edicao][carta]["quantidade"]):
				index_lista.append(int(carta))
		
		index_lista.shuffle()
		for y in index_lista:
			var carta_instancia:CARTA_BASE = CONS.CARTA_CENA.instantiate()
			armazenador_de_cartas.add_child(carta_instancia)
			carta_instancia.carregar_informacoes_da_carta(y, edicao)

func adicionar_cartas_a_colecao(_cartas:Dictionary) -> void:
	pass


func _on_botao_fechar_pressed():
	get_tree().paused = false
	queue_free()

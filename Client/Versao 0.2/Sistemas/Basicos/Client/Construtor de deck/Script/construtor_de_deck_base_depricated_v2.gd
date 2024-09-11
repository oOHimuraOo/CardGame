class_name CONSTRUTOR_DE_DECK_BASE_DEPRICATED_V2
extends CONSTRUTOR_DE_DECK_REFERENCIAS

#primeira coisa que você tem que fazer é carregar a coleção
#com a coleção carregada você deve ser capaz de:
	#passar entre as paginas da colecao.
	#dar zoom em cartas
	#selecionar cartas
signal catalogo_atualizado()
signal viewport_limpa()
signal deck_list_atualizada()
signal pagina_calculada()

const quantidade_de_maxima_de_cartas_por_paginas:int = 18

var nome_do_deck:String
var raca_do_deck:String

var quantidade_de_cartas:int = 0
var quantidade_de_cartas_possuidas:int = 0
var quantidade_de_paginas:int = 0
var pagina_atual:int = 1

var posicao_antiga:Vector2 
var escala_padrao:Vector2 = Vector2(1,1)
var escala_reduzida:Vector2 = Vector2(0.4,0.4)
var posicao_zerada:Vector2 = Vector2.ZERO
var posicao_centralizada_com_offset:Vector2 = Vector2(710,185)

var carta_lista_ativa:CARTA_LISTA

var catalogo_de_cartas:Dictionary = {
	"edicao":{
		"idx": {
			"raca": "nome_da_raca",
			"pagina": {
				"colecao": "x",
				"mutavel": "y"
			},
			"possuido": "bool",
			"quantidade": "y",
			"em_deck": {
				"nome_do_deck": 0,
			}
		},
	},
}

var deck_list:Dictionary = {
	"nome_do_deck": {
		"raca": "nome_da_raca",
		"edicao": [0,1,2,3],
		"edicao1": [0,1,2,3]
	}
}

func _ready():
	viewport_limpa.connect(alocar_cartas)
	catalogo_atualizado.connect(alocar_cartas)
	deck_list_atualizada.connect(alocar_cartas)

func gerar_catalogo(colecao:Dictionary, visualizacao_de_colecao:bool = false) -> void:
	catalogo_de_cartas.clear()
	for edicao in DATA.CardInfo:
		catalogo_de_cartas[edicao] = {}
		for idx in DATA.CardInfo[edicao]:
			quantidade_de_cartas += 1
			catalogo_de_cartas[edicao][int(idx)] = {}
			catalogo_de_cartas[edicao][int(idx)]["raca"] = DATA.CardInfo[edicao][idx]["Tipo"]
			catalogo_de_cartas[edicao][int(idx)]["pagina"] = {}
			catalogo_de_cartas[edicao][int(idx)]["pagina"]["colecao"] = arredondar(quantidade_de_cartas, quantidade_de_maxima_de_cartas_por_paginas)
			catalogo_de_cartas[edicao][int(idx)]["pagina"]["mutavel"] = contar_e_arredondar(edicao, int(idx), DATA.CardInfo[edicao][idx]["Tipo"])
			catalogo_de_cartas[edicao][int(idx)]["possuido"] = false
			catalogo_de_cartas[edicao][int(idx)]["quantidade"] = 0
			catalogo_de_cartas[edicao][int(idx)]["em_deck"] = {}
	
	if visualizacao_de_colecao:
		quantidade_de_paginas = arredondar(quantidade_de_cartas, quantidade_de_maxima_de_cartas_por_paginas)
	else:
		var count:int = 0
		if raca_do_deck:
			for edicao in catalogo_de_cartas:
				for idx in catalogo_de_cartas[edicao]:
					if catalogo_de_cartas[edicao][idx]["raca"] == raca_do_deck:
						count += 1
		else:
			count = 100
		quantidade_de_paginas = arredondar(count, quantidade_de_maxima_de_cartas_por_paginas)
	
	var client = get_tree().get_first_node_in_group("Client")
	var interface_principal = client.find_child("InterfacePrincipal")
	
	atualizar_colecao_no_catalogo(colecao)

func contar_e_arredondar(edicao:String, index:int, tipo:String) -> int:
	var cartas_na_edicao:Dictionary = {}
	var count:int = 0
	
	for ed in DATA.CardInfo:
		for idx in DATA.CardInfo[ed]:
			if DATA.CardInfo[ed][idx]["Tipo"] == tipo:
				if cartas_na_edicao.has(ed):
					cartas_na_edicao[ed] += 1
				else:
					cartas_na_edicao[ed] = 1
	
	for ed in cartas_na_edicao:
		if ed == edicao:
			for idx in DATA.CardInfo[ed]:
				if DATA.CardInfo[ed][idx]["Tipo"] == tipo:
					if int(idx) == int(index):
						count += 1
						break
					count += 1
			break
		count += cartas_na_edicao[ed]
	
	count = arredondar(count, quantidade_de_maxima_de_cartas_por_paginas)
	return count

func arredondar(x:int, y:int) -> int:
	var novo_valor:int = x % y
	if novo_valor == 0:
		novo_valor = floor(x/y)
	else:
		novo_valor = floor(x/y) +1
	return novo_valor

func atualizar_colecao_no_catalogo(colecao:Dictionary) -> void:
	for edicao in colecao:
		for idx in colecao[edicao]:
			idx = int(idx)
			if catalogo_de_cartas[edicao].has(idx):
				quantidade_de_cartas_possuidas += 1
				catalogo_de_cartas[edicao][idx]["possuido"] = true
				catalogo_de_cartas[edicao][idx]["quantidade"] += 1
	
	catalogo_atualizado.emit()

func liberador_de_botoes() -> void:
	var comando_de_sobreposicao:bool = false
	for filho in organizador_de_cartas.get_children():
		if filho.is_visible_in_tree():
			comando_de_sobreposicao = true
		else:
			comando_de_sobreposicao = false
			break
	
	if comando_de_sobreposicao:
		if pagina_atual == 1:
			botao_avancar.set_disabled(false)
			botao_voltar.set_disabled(true)
		elif pagina_atual == quantidade_de_paginas:
			botao_avancar.set_disabled(true)
			botao_voltar.set_disabled(false)
		else:
			botao_avancar.set_disabled(false)
			botao_voltar.set_disabled(false)
	else:
		if pagina_atual == 1:
			botao_avancar.set_disabled(true)
			botao_voltar.set_disabled(true)
		elif pagina_atual == quantidade_de_paginas:
			botao_avancar.set_disabled(true)
			botao_voltar.set_disabled(false)
		else:
			botao_avancar.set_disabled(true)
			botao_voltar.set_disabled(false)

func _process(delta):
	liberador_de_botoes()

func alocar_cartas(visualizacao_de_colecao:bool = false) -> void:
	if !visualizacao_de_colecao:
		for edicao in catalogo_de_cartas:
			for idx in catalogo_de_cartas[edicao]:
				if catalogo_de_cartas[edicao][idx]["raca"] == raca_do_deck:
					if int(pagina_atual) == int(catalogo_de_cartas[edicao][idx]["pagina"]["mutavel"]):
						for slot in array_de_slots:
							if get(slot).get_child_count() == 0:
								if catalogo_de_cartas[edicao][idx]["possuido"]:
									atualizar_contador_de_carta(edicao, int(idx), slot)
									instanciar_carta(edicao, int(idx), slot)
									break
								else:
									atualizar_contador_de_carta(edicao, int(idx), slot)
									instanciar_fundo(slot)
									break
	else:
		for edicao in catalogo_de_cartas:
			for idx in catalogo_de_cartas[edicao]:
				if int(pagina_atual) == int(catalogo_de_cartas[edicao][idx]["pagina"]["colecao"]):
					for slot in array_de_slots:
						if get(slot).get_child_count() == 0:
							if catalogo_de_cartas[edicao][idx]["possuido"]:
								atualizar_contador_de_carta(edicao, int(idx), slot)
								instanciar_carta(edicao, int(idx), slot)
								break
							else:
								atualizar_contador_de_carta(edicao, int(idx), slot)
								instanciar_fundo(slot)
								break
	
	for slot in array_de_slots:
		if get(slot).get_child_count() == 0:
			get(slot).get_parent().hide()
		else:
			get(slot).get_parent().show()

func limpar_viewport() -> void:
	for slot in array_de_slots:
		if get(slot).get_child_count() != 0:
			for filho in get(slot).get_children():
				filho.queue_free()
	
	await get_tree().create_timer(0.01).timeout
	viewport_limpa.emit()

func instanciar_carta(edicao:String, idx:int, slot:String) -> void:
	var carta_instancia:CARTA_BASE = CONS.CARTA_CENA.instantiate()
	carta_instancia.scale = escala_reduzida
	carta_instancia.position = posicao_zerada
	get(slot).add_child(carta_instancia)
	carta_instancia.carregar_informacoes_da_carta(idx,edicao)
	carta_instancia.hover_iniciado.connect(aplicar_zoom)
	carta_instancia.hover_terminado.connect(retirar_zoom)
	carta_instancia.carta_clicada.connect(modificar_deck)

func instanciar_fundo(slot:String) -> void:
	var fundo_instancia = CONS.CARTA_FUNDO_CENA.instantiate()
	fundo_instancia.scale = escala_reduzida
	fundo_instancia.position = posicao_zerada
	get(slot).add_child(fundo_instancia)

func atualizar_contador_de_carta(edicao:String, idx:int, slot:String) -> void:
	var etiqueta:String = "etiqueta_" + slot
	var quantidade_em_decks:int = 0
	
	if !catalogo_de_cartas[edicao][idx]["em_deck"].is_empty():
		for deck in catalogo_de_cartas[edicao][idx]["em_deck"]:
			for x in range(catalogo_de_cartas[edicao][idx]["em_deck"][deck]):
				quantidade_em_decks += 1
				
	get(etiqueta).set_text(str(quantidade_em_decks) + "/" + str(catalogo_de_cartas[edicao][idx]["quantidade"]))

func quando_botao_voltar_pressionado():
	pagina_atual -= 1
	if pagina_atual <= 1:
		pagina_atual = 1
	
	limpar_viewport()

func quando_botao_avancar_pressionado():
	pagina_atual += 1
	if pagina_atual >= quantidade_de_paginas:
		pagina_atual = quantidade_de_paginas
	
	limpar_viewport()

func aplicar_zoom(carta:CARTA_BASE) -> void:
	posicao_antiga = carta.global_position
	carta.aplicar_zoom_de_leitura(escala_padrao, posicao_centralizada_com_offset, 100)

func retirar_zoom(carta:CARTA_BASE) -> void:
	carta.aplicar_zoom_de_leitura(escala_reduzida, posicao_antiga, 0)

func carregar_deck(deck:Dictionary) -> void:
	nome_do_deck = deck["nome"]
	raca_do_deck = deck["raca"]
	
	deck_list.clear()
	
	deck_list[nome_do_deck] = {}
	deck_list[nome_do_deck]["raca"] = raca_do_deck
	
	for edicao in deck["cartas"]:
		deck_list[nome_do_deck][edicao] = []
		for idx in deck["cartas"][edicao]:
			deck_list[nome_do_deck][edicao].append(idx)
	
	montar_deck()
	await get_tree().create_timer(0.01).timeout
	deck_list_atualizada.emit()

func montar_deck() -> void:
	var informacoes:Dictionary = {
		"nome": "nome da carta",
		"tipo": "tipo da carta",
		"custo": 5,
	}
	
	for edicao in deck_list[nome_do_deck]:
		if edicao != "raca":
			for idx in deck_list[nome_do_deck][edicao]:
				for nome in array_de_nomes:
					if get(nome).informacoes.is_empty():
						informacoes["nome"] = DATA.CardInfo[edicao][str(idx)]["Nome"]
						informacoes["tipo"] = DATA.CardInfo[edicao][str(idx)]["Tipo"]
						informacoes["custo"] = DATA.CardInfo[edicao][str(idx)]["Valor"]
						get(nome).distribuir_informacoes(informacoes, int(idx), edicao)
						break


func modificar_deck(carta:CARTA_BASE) -> void:
	if !carta_lista_ativa:
		return
	
	var informacoes:Dictionary = {
		"nome": "nome da carta",
		"tipo": "tipo da carta",
		"custo": 5,
	}
	if carta.carta_info.index != carta_lista_ativa.idx:
		if modificar_decklist(carta):
			informacoes["nome"] = carta.carta_info.nome
			informacoes["tipo"] = carta.carta_info.tipo
			informacoes["custo"] = carta.carta_info.custo
			carta_lista_ativa.distribuir_informacoes(informacoes, carta.carta_info.index, carta.carta_info.colecao)
			carta_lista_ativa.button_pressed = false
			carta_lista_ativa = null

func modificar_decklist(carta:CARTA_BASE) -> bool:
	for edicao in deck_list[nome_do_deck]:
		if edicao != "raca":
			if edicao == carta.carta_info.colecao:
				deck_list[nome_do_deck][edicao][deck_list[nome_do_deck][edicao].find(carta_lista_ativa.idx)] = carta.carta_info.index
	
	var cartas_modificadas:bool = false
	var cartas_em_deck:int = 0
	for edicao in catalogo_de_cartas:
		for idx in catalogo_de_cartas[edicao]:
			if idx == carta.carta_info.index:
				for deck in catalogo_de_cartas[edicao][idx]["em_deck"]:
					cartas_em_deck += catalogo_de_cartas[edicao][idx]["em_deck"][deck]
				if catalogo_de_cartas[edicao][idx]["quantidade"] > cartas_em_deck:
					if catalogo_de_cartas[edicao][idx]["em_deck"].is_empty():
						cartas_modificadas = true
						catalogo_de_cartas[edicao][idx]["em_deck"][nome_do_deck] = 1
					else:
						for deck in catalogo_de_cartas[edicao][idx]["em_deck"]:
							if deck == nome_do_deck:
								cartas_modificadas = true
								catalogo_de_cartas[edicao][idx]["em_deck"][deck] += 1
	
	limpar_viewport()
	return cartas_modificadas

func quando_carta_lista_pressionado():
	if carta_lista_ativa != carta_lista:
		carta_lista_ativa = carta_lista
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_2_pressionado():
	if carta_lista_ativa != carta_lista_2:
		carta_lista_ativa = carta_lista_2
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_3_pressionado():
	if carta_lista_ativa != carta_lista_3:
		carta_lista_ativa = carta_lista_3
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_4_pressionado():
	if carta_lista_ativa != carta_lista_4:
		carta_lista_ativa = carta_lista_4
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_5_pressionado():
	if carta_lista_ativa != carta_lista_5:
		carta_lista_ativa = carta_lista_5
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_6_pressionado():
	if carta_lista_ativa != carta_lista_6:
		carta_lista_ativa = carta_lista_6
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_7_pressionado():
	if carta_lista_ativa != carta_lista_7:
		carta_lista_ativa = carta_lista_7
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_8_pressionado():
	if carta_lista_ativa != carta_lista_8:
		carta_lista_ativa = carta_lista_8
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_9_pressionado():
	if carta_lista_ativa != carta_lista_9:
		carta_lista_ativa = carta_lista_9
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_10_pressionado():
	if carta_lista_ativa != carta_lista_10:
		carta_lista_ativa = carta_lista_10
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_11_pressionado():
	if carta_lista_ativa != carta_lista_11:
		carta_lista_ativa = carta_lista_11
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_12_pressionado():
	if carta_lista_ativa != carta_lista_12:
		carta_lista_ativa = carta_lista_12
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_13_pressionado():
	if carta_lista_ativa != carta_lista_13:
		carta_lista_ativa = carta_lista_13
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_14_pressionado():
	if carta_lista_ativa != carta_lista_14:
		carta_lista_ativa = carta_lista_14
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func quando_carta_lista_15_pressionado():
	if carta_lista_ativa != carta_lista_15:
		carta_lista_ativa = carta_lista_15
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

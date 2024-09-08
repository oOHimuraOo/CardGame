class_name CONSTRUTOR_DE_DECK_BASE
extends CONSTRUTOR_DE_DECK_REFERENCIAS

signal nome_do_deck_atualizado(novo_nome:String)
signal tipo_do_deck_atualizado(novo_tipo:String)
signal catalogo_atualizado()
signal deck_list_atualizada()
signal cartas_removidas()

const quantidade_maxima_de_cartas_por_pagina:int = 18
const escala_padrao:Vector2 = Vector2(1,1)
const escala_reduzida:Vector2 = Vector2(0.4,0.4)
const posicao_zerada:Vector2 = Vector2.ZERO
const posicao_centralizada_com_offset:Vector2 = Vector2(710,185)

var nome_do_deck:String
var tipo_do_deck:String

var quantidade_de_cartas_total:int = 0

var quantidade_de_paginas_total:int = 0
var pagina_atual:int = 1

var catalogo_de_cartas:CATALOGO_DE_CARTAS
var decklist:DECKLIST

var visualizacao_colecao:bool = false

var posicao_antiga:Vector2

var carta_lista_ativa:CARTA_LISTA

var mudanca_efetuada: bool = false

func inicializar_mostruario(modo_colecao:bool) -> void:
	visualizacao_colecao = modo_colecao
	iniciar_decklist()
	
	await decklist.deck_list_carregada
	
	iniciar_catalogo()
	contar_cartas_no_catalogo()
	contar_paginas()
	conectar_sinais()

func conectar_sinais() -> void:
	#nome_do_deck_atualizado.connect()
	#tipo_do_deck_atualizado.connect()
	deck_list_atualizada.connect(revelar_cartas_possuidas)
	catalogo_atualizado.connect(revelar_cartas_possuidas)
	cartas_removidas.connect(revelar_cartas_possuidas)
	for item:CARTA_LISTA in organizador_cartas_lista.get_children():
		item.pressionado.connect(quando_carta_lista_pressionado)

func contar_cartas_no_catalogo() -> void:
	for edicao in DATA.CardInfo:
		for idx in DATA.CardInfo[edicao]:
			quantidade_de_cartas_total += 1

func contar_paginas() -> void:
	if visualizacao_colecao:
		quantidade_de_paginas_total = arredondar(int(quantidade_de_cartas_total), int(quantidade_maxima_de_cartas_por_pagina))
		var carta_atual:int = 0
		for edicao in catalogo_de_cartas.catalogo:
			for idx in catalogo_de_cartas.catalogo[edicao]:
				carta_atual += 1
				catalogo_de_cartas.catalogo[edicao][idx]["pagina"]["colecao"] = arredondar(carta_atual, quantidade_maxima_de_cartas_por_pagina)
	else:
		var maior_valor_encontrado:int
		for edicao in catalogo_de_cartas.catalogo:
			for idx in catalogo_de_cartas.catalogo[edicao]:
				var tipo = catalogo_de_cartas.catalogo[edicao][idx]["raca"]
				if maior_valor_encontrado < alocar_pagina_mutavel(edicao, idx, tipo):
					maior_valor_encontrado = alocar_pagina_mutavel(edicao, idx, tipo)
				catalogo_de_cartas.catalogo[edicao][idx]["pagina"]["mutavel"] = alocar_pagina_mutavel(edicao, idx, tipo)
		quantidade_de_paginas_total = maior_valor_encontrado

func iniciar_decklist() -> void:
	decklist = DECKLIST.new()
	decklist.nome_encontrado.connect(registrar_nome)
	decklist.raca_encontrada.connect(registrar_raca)
	decklist.deck_list_carregada.connect(revelar_decklist)

func revelar_decklist() -> void:
	var informacoes:Dictionary = {
		"nome": "nome da carta",
		"tipo": ["tipo da carta"],
		"custo": 5,
	}
	
	for nome in decklist.decklist:
		for edicao in decklist.decklist[nome]["cartas"]:
			for idx in decklist.decklist[nome]["cartas"][edicao]:
				adicionar_contagem_inicial_de_cartas(edicao, idx)
				for filho in organizador_cartas_lista.get_children():
					if filho.informacoes.is_empty():
						informacoes["nome"] = DATA.CardInfo[edicao][str(idx)]["Nome"]
						informacoes["tipo"] = [DATA.CardInfo[edicao][str(idx)]["Tipo"]]
						informacoes["custo"] = DATA.CardInfo[edicao][str(idx)]["Valor"]
						filho.distribuir_informacoes(informacoes, idx, edicao)
						break

func adicionar_contagem_inicial_de_cartas(edicao:String, index:int) -> void:
	await catalogo_atualizado
	
	var interface_principal = get_tree().get_first_node_in_group("Client").find_child("InterfacePrincipal")
	var acount_info = interface_principal.AccountInfo
	var cartas_em_deck:int = 0
	
	for edc in catalogo_de_cartas.catalogo:
		for idx in catalogo_de_cartas.catalogo[edc]:
			if idx == index:
				for deck in acount_info["decks_do_jogador"]:
					if acount_info["decks_do_jogador"][deck]["cartas"].has(edc):
						var array_convertido = converter_para_modelo_padrao(acount_info["decks_do_jogador"][deck]["cartas"][edc])
						cartas_em_deck += array_convertido.count(int(idx))
				if edicao == edc:
					if catalogo_de_cartas.catalogo[edc][idx]["quantidade"] >= cartas_em_deck:
						if catalogo_de_cartas.catalogo[edc][idx]["em_deck"].is_empty():
							catalogo_de_cartas.catalogo[edc][idx]["em_deck"][nome_do_deck] = cartas_em_deck
						else:
							for deck in catalogo_de_cartas.catalogo[edc][idx]["em_deck"]:
								catalogo_de_cartas.catalogo[edc][idx]["em_deck"][deck] = cartas_em_deck + 1

func converter_para_modelo_padrao(array:Array) -> Array:
	var novo_array:Array = []
	for x in array:
		novo_array.append(int(x))
	return novo_array

func registrar_nome(nome:String) -> void:
	nome_do_deck = nome

func registrar_raca(raca:String) -> void:
	tipo_do_deck = raca

func iniciar_catalogo() -> void:
	catalogo_de_cartas = CATALOGO_DE_CARTAS.new()
	catalogo_de_cartas.gerar_catalogo()

func arredondar(x:int, y:int) -> int:
	var novo_valor:int = x % y
	if novo_valor == 0:
		novo_valor = floor(int(float(x)/float(y)))
	else:
		novo_valor = floor(int(float(x)/float(y))) +1
	return novo_valor

func alocar_pagina_mutavel(edicao:String, index:int, tipo:Array) -> int:
	var cartas_na_edicao:Dictionary = {}
	var tipo_1:String
	var tipo_2:String
	
	for t in tipo:
		if tipo_1.is_empty():
			tipo_1 = t
		else:
			tipo_2 = t
  
	if tipo_1 == "Nenhum" || tipo_1 == "Todos":
		tipo_1 = tipo_do_deck
  
	if tipo_1 != tipo_do_deck:
		if tipo_2 == tipo_do_deck:
			tipo_1 = tipo_do_deck
			tipo_2 = "" 
	else:
		if tipo_2 != tipo_do_deck:
			tipo_2 = ""
  
	var pagina_atual_temp:int = 1
	var posicao_atual_temp:int = -1
	for ed in DATA.CardInfo:
		for idx in DATA.CardInfo[ed]:
			if DATA.CardInfo[ed][idx]["Tipo"].has(tipo_1) || DATA.CardInfo[ed][idx]["Tipo"].has("Nenhum")  || DATA.CardInfo[ed][idx]["Tipo"].has("Todos"):
				posicao_atual_temp += 1
				if posicao_atual_temp >= 18:
					pagina_atual_temp += 1
					posicao_atual_temp = 0
				if !cartas_na_edicao.has(ed):
					cartas_na_edicao[ed] = {}
				if !cartas_na_edicao[ed].has(idx):
					cartas_na_edicao[ed][int(idx)] = {}
				cartas_na_edicao[ed][int(idx)]["pagina"] = pagina_atual_temp
				cartas_na_edicao[ed][int(idx)]["posicao"] = posicao_atual_temp
  
	return cartas_na_edicao[edicao][index]["pagina"]

func inicializar_colecao(informacao:Dictionary) -> void:
	await decklist.deck_list_carregada
	catalogo_de_cartas.registrar_posse(informacao)
	catalogo_atualizado.emit()

func revelar_cartas_possuidas() -> void:
	var catalogo:Dictionary = catalogo_de_cartas.catalogo
	if !visualizacao_colecao:
		for edicao in catalogo:
			for idx in catalogo[edicao]:
				if comparador_de_tipo(edicao, idx) && comparador_de_pagina(edicao, idx):
					for slot in array_de_slots:
						if get(slot).get_child_count() == 0:
							if catalogo[edicao][idx]["possuido"]:
								atualizar_contador_de_carta(edicao, int(idx), slot)
								instanciar_carta(edicao, int(idx), slot)
								break
							else:
								atualizar_contador_de_carta(edicao, int(idx), slot)
								instanciar_fundo(slot)
								break
	else:
		for edicao in catalogo:
			for idx in catalogo[edicao]:
				if comparador_de_pagina(edicao, idx):
					for slot in array_de_slots:
						if get(slot).get_child_count() == 0:
							if catalogo[edicao][idx]["possuido"]:
								atualizar_contador_de_carta(edicao, int(idx), slot)
								instanciar_carta(edicao, int(idx), slot)
								break
							else:
								atualizar_contador_de_carta(edicao, int(idx), slot)
								instanciar_fundo(slot)
								break
	
	for filho in organizador_de_cartas.get_children():
		if filho.get_child(0).get_child_count() == 0:
			filho.hide()
		else:
			filho.show()

func comparador_de_tipo(edicao:String, idx:int) -> bool:
	if catalogo_de_cartas.catalogo[edicao][idx]["raca"].has(tipo_do_deck):
		return true
	if catalogo_de_cartas.catalogo[edicao][idx]["raca"].has("Nenhum"):
		return true
	if catalogo_de_cartas.catalogo[edicao][idx]["raca"].has("Todos"):
		return true
	return false

func comparador_de_pagina(edicao:String, idx:int) -> bool:
	if pagina_atual == catalogo_de_cartas.catalogo[edicao][idx]["pagina"]["colecao"] || pagina_atual == catalogo_de_cartas.catalogo[edicao][idx]["pagina"]["mutavel"]:
		return true
	return false

func atualizar_contador_de_carta(edicao:String, idx:int, slot:String) -> void:
	var etiqueta:String = "etiqueta_" + slot
	var quantidade_em_decks:int = 0
	
	if !catalogo_de_cartas.catalogo[edicao][idx]["em_deck"].is_empty():
		for deck in catalogo_de_cartas.catalogo[edicao][idx]["em_deck"]:
			for x in range(catalogo_de_cartas.catalogo[edicao][idx]["em_deck"][deck]):
				quantidade_em_decks += 1
	
	get(etiqueta).set_text(str(quantidade_em_decks) + "/" + str(catalogo_de_cartas.catalogo[edicao][idx]["quantidade"]))

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

func aplicar_zoom(carta:CARTA_BASE) -> void:
	posicao_antiga = carta.global_position
	carta.aplicar_zoom_de_leitura(escala_padrao, posicao_centralizada_com_offset, 100)

func retirar_zoom(carta:CARTA_BASE) -> void:
	carta.aplicar_zoom_de_leitura(escala_reduzida, posicao_antiga, 0)

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
	
	deck_list_atualizada.emit()

func modificar_decklist(carta:CARTA_BASE) -> bool:
	#roda o dicionario até encontrar a opção correta dentro dele.
	for edicao in decklist.decklist[nome_do_deck]["cartas"]:
		#se a colecao atual for a mesma que a colecao da carta antiga
		if edicao == carta_lista_ativa.edc:
			#remove o index de uma carta especifica na posição especifica do array
			decklist.decklist[nome_do_deck]["cartas"][edicao].remove_at(decklist.decklist[nome_do_deck]["cartas"][edicao].find(carta_lista_ativa.idx))
	
	var count:int = 0
	for edicao in decklist.decklist[nome_do_deck]["cartas"]:
		count += decklist.decklist[nome_do_deck]["cartas"][edicao].size()
	
	if count == 14:
		if decklist.decklist[nome_do_deck]["cartas"].has(carta.carta_info.colecao):
			decklist.decklist[nome_do_deck]["cartas"][carta.carta_info.colecao].append(carta.carta_info.index)
		else:
			decklist.decklist[nome_do_deck]["cartas"][carta.carta_info.colecao] = [carta.carta_info.index]
		
	
	#vai verificar todas as edicoes
	for edicao in catalogo_de_cartas.catalogo:
		#vai verificar todos os indices
		for idx in catalogo_de_cartas.catalogo[edicao]:
			#se a edicao for a mesma que a antiga
			if edicao == carta_lista_ativa.edc:
				#se o indice for o mesmo que o antigo
				if idx == carta_lista_ativa.idx:
					#reduz a quantidade de cartas no deck em 1
					catalogo_de_cartas.catalogo[edicao][idx]["em_deck"][nome_do_deck] -= 1
	
	#verifica se já existiu alguma alteração
	var cartas_modificadas:bool = false
	#conta as cartas no deck
	var cartas_em_deck:int = 0
	
	#vai verificar todas as ediçoões
	for edicao in catalogo_de_cartas.catalogo:
		#vai verificar todos os indices dentro de cada uma das edições
		for idx in catalogo_de_cartas.catalogo[edicao]:
			#se a edicao atual for igual ao da carta recebida no parametro
			if edicao == carta.carta_info.colecao:
				#Se o indice atual for igual ao da carta recebida no parametro
				if idx == carta.carta_info.index:
					#vai rodar por todos os decks dentro do catalogo, dentro da chave edicao, idx, "em_deck"
					for deck in catalogo_de_cartas.catalogo[edicao][idx]["em_deck"]:
						#adiciona o valor registrado dentro da chave deck ao cartas em deck.
						cartas_em_deck += catalogo_de_cartas.catalogo[edicao][idx]["em_deck"][deck]
					#se a quantidade de copias dessa carta na coleção for maior que a quantidade de cartas em deck
					if catalogo_de_cartas.catalogo[edicao][idx]["quantidade"] > cartas_em_deck:
						#se a carta em questão não possuir ainda uma entrada na chave "em_deck" 
						if catalogo_de_cartas.catalogo[edicao][idx]["em_deck"].is_empty():
							#registra que uma alteração foi feita
							cartas_modificadas = true
							#cria uma entrada na chave em_deck com o valor padrão 1.
							catalogo_de_cartas.catalogo[edicao][idx]["em_deck"][nome_do_deck] = 1
						else:
							for deck in catalogo_de_cartas.catalogo[edicao][idx]["em_deck"]:
								#registra que uma alteração foi feita
								cartas_modificadas = true
								for x in range(catalogo_de_cartas.catalogo[edicao][idx]["em_deck"][deck]):
									#coleta a entrada já existente e aumenta seu valor em 1.
									catalogo_de_cartas.catalogo[edicao][idx]["em_deck"][deck] += 1
	
	limpar_pagina()
	mudanca_efetuada = cartas_modificadas
	return cartas_modificadas

func quando_botao_voltar_pressionado():
	pagina_atual -= 1
	if pagina_atual <= 1:
		pagina_atual = 1
	
	limpar_pagina()

func quando_botao_avancar_pressionado():
	pagina_atual += 1
	if pagina_atual >= quantidade_de_paginas_total:
		pagina_atual = quantidade_de_paginas_total
	
	limpar_pagina()

func limpar_pagina() -> void:
	for slot in array_de_slots:
		if get(slot).get_child_count() != 0:
			for filho in get(slot).get_children():
				filho.queue_free()
	
	await get_tree().create_timer(0.01).timeout
	cartas_removidas.emit()

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
		elif pagina_atual == quantidade_de_paginas_total:
			botao_avancar.set_disabled(true)
			botao_voltar.set_disabled(false)
		else:
			botao_avancar.set_disabled(false)
			botao_voltar.set_disabled(false)
	else:
		if pagina_atual == 1:
			botao_avancar.set_disabled(true)
			botao_voltar.set_disabled(true)
		elif pagina_atual == quantidade_de_paginas_total:
			botao_avancar.set_disabled(true)
			botao_voltar.set_disabled(false)
		else:
			botao_avancar.set_disabled(true)
			botao_voltar.set_disabled(false)

func _process(_delta):
	liberador_de_botoes()
	
	if mudanca_efetuada:
		etiqueta_aplicar_mudanca.set_text("Aplicar")
	else:
		etiqueta_aplicar_mudanca.set_text("Fechar")

func quando_carta_lista_pressionado(item:TextureButton) -> void:
	if carta_lista_ativa != item:
		carta_lista_ativa = item
		for filho in carta_lista_ativa.get_parent().get_children():
			if filho != carta_lista_ativa:
				filho.button_pressed = false
	else:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = null

func _on_botao_aplicar_mudanca_pressed():
	if mudanca_efetuada:
		SERVER.enviando.deck_modificado(decklist.decklist, tipo_do_deck)
	else:
		fechar_pagina()

func exibir_popup_de_confirmacao_de_validacao_de_deck(validacao:bool, msg:String) -> void:
	if validacao:
		var popup_intancia:POP_UP_INTERFACE = CONS.POP_UP_GENERICO_CENA.instantiate()
		get_tree().root.add_child(popup_intancia)
		popup_intancia.mudar_texto_do_pop_up(msg, validacao, true)
		get_tree().paused = true
	else:
		var popup_intancia:POP_UP_INTERFACE = CONS.POP_UP_GENERICO_CENA.instantiate()
		get_tree().root.add_child(popup_intancia)
		popup_intancia.mudar_texto_do_pop_up(msg, validacao, true)
		get_tree().paused = true

func fechar_pagina():
	self.queue_free()

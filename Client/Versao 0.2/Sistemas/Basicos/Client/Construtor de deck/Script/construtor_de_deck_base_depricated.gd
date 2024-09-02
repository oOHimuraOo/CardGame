class_name CONSTRUTOR_DE_DECK_BASE_DEPRICATED
extends CONSTRUTOR_DE_DECK_REFERENCIAS

signal cartas_limpas()
signal deck_list_carregado()

var raca:String

var deck_list:Dictionary = {}
var cartas_carregadas:Dictionary = {}
var cartas_atuais:Dictionary = {}
var cartas_faltando:Dictionary = {}

var index_minimo:int = 0
var index_maximo:int = 18
var pagina_de_colecao_atual:int = 0
var quantidade_de_cartas:int = 0

var posicao_antiga:Vector2 = Vector2.ZERO

var carta_lista_ativa:TextureButton
var idx_ativo:int

func carregar_colecao(colecao:Dictionary, primeiro_load:bool = true) -> void:
	if colecao.is_empty():
		return
	
	if primeiro_load:
		for edicao in colecao:
			organizar_array(colecao[edicao], index_minimo, colecao[edicao].size() - 1)
	
	for edicao in colecao:
		cartas_atuais[edicao] = []
		for index in colecao[edicao]:
			if primeiro_load:
				quantidade_de_cartas += 1
			for slot in array_de_slots:
				if get(slot).get_child_count() == 0:
					if index:
						cartas_atuais[edicao].append(index)
						var carta_instancia:CARTA_BASE = CONS.CARTA_CENA.instantiate()
						carta_instancia.scale = Vector2(0.4,0.4)
						get(slot).add_child(carta_instancia)
						carta_instancia.carregar_informacoes_da_carta(index,edicao)
						carta_instancia.hover_iniciado.connect(aplicar_zoom)
						carta_instancia.hover_terminado.connect(retirar_zoom)
						carta_instancia.carta_clicada.connect(mudar_carta_no_deck)
						break
	
	verificar_disponibilidade_de_botoes()
	
	cartas_faltando = colecao.duplicate(true)
	for edicao in cartas_atuais:
		for index in cartas_atuais[edicao]:
			cartas_faltando[edicao].erase(index)
	
	await deck_list_carregado || !deck_list.is_empty()
	revelar_cartas_no_deck()

func carregar_deck(deck:Dictionary) -> void:
	raca = deck["raca"]
	for edicao in deck["cartas"]:
		for index in deck["cartas"][edicao]:
			if !deck_list.has(edicao):
				deck_list[edicao] = {}
			
			if !deck_list[edicao].has(index):
					deck_list[edicao][index] = {}
					
			if deck_list[edicao][index].is_empty():
				deck_list[edicao][index]["nome"] = DATA.CardInfo[edicao][str(index)]["Nome"]
				deck_list[edicao][index]["tipo"] = DATA.CardInfo[edicao][str(index)]["Tipo"]
				deck_list[edicao][index]["custo"] = DATA.CardInfo[edicao][str(index)]["Valor"]
				deck_list[edicao][index]["quantidade"] = 1
			else:
				deck_list[edicao][index]["quantidade"] += 1
	
	alocar_cartas_na_lista()
	deck_list_carregado.emit()

func alocar_cartas_na_lista() -> void:
	for item in deck_list:
		for x in deck_list[item]:
			for y in range(deck_list[item][x]["quantidade"]):
				for nome in array_de_nomes:
					if get(nome).informacoes.is_empty():
						get(nome).distribuir_informacoes(deck_list[item][x], int(x))
						break

func _on_botao_voltar_pressed():
	pagina_de_colecao_atual -= 1
	if pagina_de_colecao_atual <= 0:
		pagina_de_colecao_atual = 0
	
	limpar_cartas(false)
	await cartas_limpas
	voltar_pagina_de_colecao(cartas_carregadas)

func _on_botao_avancar_pressed():
	pagina_de_colecao_atual += 1
	if pagina_de_colecao_atual >= ceil(quantidade_de_cartas/index_maximo):
		pagina_de_colecao_atual = ceil(quantidade_de_cartas/index_maximo)
	
	limpar_cartas(true)
	await cartas_limpas
	carregar_colecao(cartas_faltando, false)

func verificar_disponibilidade_de_botoes() -> void:
	if pagina_de_colecao_atual == 0:
		botao_avancar.set_disabled(false)
		botao_voltar.set_disabled(true)
	elif pagina_de_colecao_atual == ceil(quantidade_de_cartas/index_maximo):
		botao_avancar.set_disabled(true)
		botao_voltar.set_disabled(false)
	else:
		botao_avancar.set_disabled(false)
		botao_voltar.set_disabled(false)

func limpar_cartas(avancando:bool) -> void:
	for slot in array_de_slots:
		if get(slot).get_child_count() != 0:
			get(slot).get_child(0).hover_iniciado.disconnect(aplicar_zoom)
			get(slot).get_child(0).hover_terminado.disconnect(retirar_zoom)
			get(slot).get_child(0).queue_free()
	
	var cartas_atuais_dupl_temp:Dictionary = cartas_atuais.duplicate(true)
	if avancando:
		for edicao in cartas_atuais_dupl_temp:
			if !cartas_carregadas.has(edicao):
				cartas_carregadas[edicao] = []
			for index in cartas_atuais_dupl_temp[edicao]:
				cartas_carregadas[edicao].append(cartas_atuais[edicao].pop_front())
	else:
		for edicao in cartas_atuais_dupl_temp:
			if !cartas_faltando.has(edicao):
				cartas_faltando[edicao] = []
			cartas_atuais[edicao].reverse()
			for index in cartas_atuais_dupl_temp[edicao]:
				cartas_faltando[edicao].push_front(cartas_atuais[edicao].pop_front())
	
	reorganizar_colecao()
	
	await get_tree().create_timer(0.1).timeout
	cartas_limpas.emit()

func voltar_pagina_de_colecao(colecao:Dictionary) -> void:
	if colecao.is_empty():
		return
	
	verificar_disponibilidade_de_botoes()
	
	var count:int = 0
	for edicao in colecao:
		cartas_atuais[edicao] = []
		for index in colecao[edicao]:
			if count < pagina_de_colecao_atual * index_maximo:
					count += 1
			else:
				for slot in array_de_slots:
					if get(slot).get_child_count() == 0:
						if index:
							cartas_atuais[edicao].append(index)
							var carta_instancia:CARTA_BASE = CONS.CARTA_CENA.instantiate()
							carta_instancia.scale = Vector2(0.4,0.4)
							get(slot).add_child(carta_instancia)
							carta_instancia.carregar_informacoes_da_carta(index,edicao)
							carta_instancia.hover_iniciado.connect(aplicar_zoom)
							carta_instancia.hover_terminado.connect(retirar_zoom)
							carta_instancia.carta_clicada.connect(mudar_carta_no_deck)
							break
	
	cartas_carregadas = colecao.duplicate(true)
	for edicao in cartas_atuais:
		for index in cartas_atuais[edicao]:
			cartas_carregadas[edicao].erase(index)
	
	revelar_cartas_no_deck()

func reorganizar_colecao() -> void:
	for edicao in cartas_atuais:
		organizar_array(cartas_atuais[edicao], index_minimo, cartas_atuais[edicao].size() - 1)
	
	for edicao in cartas_carregadas:
		organizar_array(cartas_carregadas[edicao], index_minimo, cartas_carregadas[edicao].size() - 1)
	
	for edicao in cartas_faltando:
		organizar_array(cartas_faltando[edicao], index_minimo, cartas_faltando[edicao].size() - 1)

func organizar_array(lista:Array, menor_valor:int, maior_valor:int) -> void:
	if lista.is_empty():
		return
	if menor_valor < maior_valor:
		var index_primario = particao_do_algoritimo(lista, menor_valor, maior_valor)
		organizar_array(lista, menor_valor, index_primario - 1)
		organizar_array(lista,index_primario + 1, maior_valor)
	
func particao_do_algoritimo(lista:Array, menor_valor:int, maior_valor:int) -> int:
	var pivot:int = lista[maior_valor]
	var i:int = menor_valor - 1
	for j in range(menor_valor, maior_valor):
		if lista[j] <= pivot:
			i += 1
			var valor_temp = lista[i]
			lista[i] = lista[j]
			lista[j] = valor_temp
	lista[maior_valor] = lista[i+1]
	lista[i+1] = pivot
	return i+1

func aplicar_zoom(carta:CARTA_BASE) -> void:
	posicao_antiga = carta.global_position
	carta.aplicar_zoom_de_leitura(Vector2(1,1),Vector2(710,185), 100)

func retirar_zoom(carta:CARTA_BASE) -> void:
	carta.aplicar_zoom_de_leitura(Vector2(0.4,0.4), posicao_antiga, 0)

func _on_botao_aplicar_mudanca_pressed():
	SERVER.enviando.deck_modificado(deck_list, raca)

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

func _on_carta_lista_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista
		idx_ativo = carta_lista.idx
	else:
		carta_lista_ativa = carta_lista
		idx_ativo = carta_lista.idx

func _on_carta_lista_2_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_2:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_2
		idx_ativo = carta_lista_2.idx
	else:
		carta_lista_ativa = carta_lista_2
		idx_ativo = carta_lista_2.idx

func _on_carta_lista_3_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_3:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_3
		idx_ativo = carta_lista_3.idx
	else:
		carta_lista_ativa = carta_lista_3
		idx_ativo = carta_lista_3.idx

func _on_carta_lista_4_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_4:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_4
		idx_ativo = carta_lista_4.idx
	else:
		carta_lista_ativa = carta_lista_4
		idx_ativo = carta_lista_4.idx

func _on_carta_lista_5_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_5:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_5
		idx_ativo = carta_lista_5.idx
	else:
		carta_lista_ativa = carta_lista_5
		idx_ativo = carta_lista_5.idx

func _on_carta_lista_6_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_6:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_6
		idx_ativo = carta_lista_6.idx
	else:
		carta_lista_ativa = carta_lista_6
		idx_ativo = carta_lista_6.idx

func _on_carta_lista_7_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_7:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_7
		idx_ativo = carta_lista_7.idx
	else:
		carta_lista_ativa = carta_lista_7
		idx_ativo = carta_lista_7.idx

func _on_carta_lista_8_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_8:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_8
		idx_ativo = carta_lista_8.idx
	else:
		carta_lista_ativa = carta_lista_8
		idx_ativo = carta_lista_8.idx

func _on_carta_lista_9_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_9:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_9
		idx_ativo = carta_lista_9.idx
	else:
		carta_lista_ativa = carta_lista_9
		idx_ativo = carta_lista_9.idx

func _on_carta_lista_10_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_10:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_10
		idx_ativo = carta_lista_10.idx
	else:
		carta_lista_ativa = carta_lista_10
		idx_ativo = carta_lista_10.idx

func _on_carta_lista_11_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_11:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_11
		idx_ativo = carta_lista_11.idx
	else:
		carta_lista_ativa = carta_lista_11
		idx_ativo = carta_lista_11.idx

func _on_carta_lista_12_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_12:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_12
		idx_ativo = carta_lista_12.idx
	else:
		carta_lista_ativa = carta_lista_12
		idx_ativo = carta_lista_12.idx

func _on_carta_lista_13_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_13:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_13
		idx_ativo = carta_lista_13.idx
	else:
		carta_lista_ativa = carta_lista_13
		idx_ativo = carta_lista_13.idx

func _on_carta_lista_14_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_14:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_14
		idx_ativo = carta_lista_14.idx
	else:
		carta_lista_ativa = carta_lista_14
		idx_ativo = carta_lista_14.idx

func _on_carta_lista_15_pressed():
	if carta_lista_ativa && carta_lista_ativa != carta_lista_15:
		carta_lista_ativa.button_pressed = false
		carta_lista_ativa = carta_lista_15
		idx_ativo = carta_lista_15.idx
	else:
		carta_lista_ativa = carta_lista_15
		idx_ativo = carta_lista_15.idx

func mudar_carta_no_deck(carta:CARTA_BASE) -> void:
	#carta_lista_ativa.distribuir_informacoes(informacoes, carta.carta_info.index)
	pass



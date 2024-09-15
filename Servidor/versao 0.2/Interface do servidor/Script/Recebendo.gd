class_name RECEBENDO
extends Node

var testador:Dictionary = {0: "TYPE_NIL", 1: "TYPE_BOOL", 2: "TYPE_INT", 3: "TYPE_FLOAT", 4: "TYPE_STRING", 5:"TYPE_VECTOR2", 6: "TYPE_VECTOR2I", 7: "TYPE_RECT2", 8: "TYPE_RECT2I", 9: "TYPE_VECTOR3", 10: "TYPE_VECTOR3I", 11: "TYPE_TRANSFORM2D", 12: "TYPE_VECTOR4", 13: "TYPE_VECTOR4I",14: "TYPE_PLANE", 15: "TYPE_QUATERNION", 16:"TYPE_AABB", 17:"TYPE_BASIS", 18:"TYPE_TRANSFORM3D", 19:"TYPE_PROJECTION", 20:"TYPE_COLOR", 21:"TYPE_STRING_NAME", 22:"TYPE_NODE_PATH", 23:"TYPE_RID", 24:"TYPE_OBJECT", 25:"TYPE_CALLABLE", 26:"TYPE_SIGNAL", 27:"TYPE_DICTIONARY", 28:"TYPE_ARRAY", 29:"TYPE_PACKED_BYTE_ARRAY", 30:"TYPE_PACKED_INT32_ARRAY", 31:"TYPE_PACKED_INT64_ARRAY", 32:"TYPE_PACKED_FLOAT32_ARRAY", 33:"TYPE_PACKED_FLOAT64_ARRAY", 34:"TYPE_PACKED_STRING_ARRAY", 35: "TYPE_PACKED_VECTOR2_ARRAY", 36:"TYPE_PACKED_VECTOR3_ARRAY", 37:"TYPE_PACKED_COLOR_ARRAY", 38:"TYPE_MAX"}
var fila_de_compra:Array[int] = []

func verificar_possibilidade_de_deck_list(deck_list:Dictionary, raca:String, client:String, id:int) -> void:
	var usuario_real:String = get_parent().iniciando.aplicar_regra_hash_de_usuario(client)
	var novo_deck:Dictionary = converter_modelo_de_dicionario_de_deck_para_modelo_padrao(deck_list)
	
	if verificar_tamanho_do_deck(novo_deck):
		var msg_a:String = "Baralho nao atualizado! \nTamanho de deck invalido: Erro 001!"
		get_parent().enviando.finalizando_alteracao_de_deck(id, false, msg_a)
		return
	
	if verificar_existencia_de_cartas_na_colecao(novo_deck, usuario_real):
		var msg_b:String = "Baralho nao atualizado! \nCarta nao existente na colecao: Erro 002!"
		get_parent().enviando.finalizando_alteracao_de_deck(id, false, msg_b)
		return
	
	if verificar_quantidade_de_cartas_na_colecao(novo_deck, usuario_real):
		var msg_c:String = "Baralho nao atualizado! \nQuantidade de cartas invalida: Erro 003!"
		get_parent().enviando.finalizando_alteracao_de_deck(id, false, msg_c)
		return
	
	var msg:String = "Baralho atualizado com sucesso!"
	DATA.atualizar_deck(usuario_real, deck_list, raca)
	get_parent().enviando.finalizando_alteracao_de_deck(id, true, msg)

func verificar_tamanho_do_deck(deck:Dictionary) -> bool:
	var count:int = 0
	
	for edicao in deck:
		count += deck[edicao].size()
	
	if count == 15:
		return false
	
	return true

func verificar_existencia_de_cartas_na_colecao(deck:Dictionary, usuario:String) -> bool:
	var colecao_convertida:Dictionary = converter_colecao_para_modelo_padrao(usuario)
	for edicao in deck:
		for idx in deck[edicao]:
			if !colecao_convertida[edicao].has(idx):
				return true
	return false

func verificar_quantidade_de_cartas_na_colecao(deck:Dictionary, usuario:String) -> bool:
	var colecao_convertida:Dictionary = converter_colecao_para_modelo_padrao(usuario)
	var count:int = 0
	for edicao in deck:
		for idx in deck[edicao]:
			count = 0
			for baralho in DATA.UserData[usuario]["informcoes_do_jogador"]["decks_do_jogador"]:
				var deck_registrado_convertido:Dictionary = converter_deck_para_modelo_padrao(usuario, baralho)
				if deck_registrado_convertido.has(edicao):
					if deck_registrado_convertido[edicao].has(idx):
						count += deck_registrado_convertido[edicao].count(idx)
			
			if deck[edicao].count(idx) > colecao_convertida[edicao].count(idx):
				return true
			
			if count > colecao_convertida[edicao].count(idx):
				return true
			
	return false

func converter_deck_para_modelo_padrao(usuario:String, deck:String) -> Dictionary:
	var dicionario:Dictionary = {}
	for edicao in DATA.UserData[usuario]["informcoes_do_jogador"]["decks_do_jogador"][deck]["cartas"]:
		dicionario[edicao] = []
		for idx in DATA.UserData[usuario]["informcoes_do_jogador"]["decks_do_jogador"][deck]["cartas"][edicao]:
			dicionario[edicao].append(idx)
	return dicionario

func converter_modelo_de_dicionario_de_deck_para_modelo_padrao(deck_list:Dictionary) -> Dictionary:
	var dicionario:Dictionary = {}
	for nome in deck_list:
		for edicao in deck_list[nome]["cartas"]:
			dicionario[edicao] = []
			for index in deck_list[nome]["cartas"][edicao]:
				dicionario[edicao].append(int(index))
	return dicionario

func converter_colecao_para_modelo_padrao(usuario:String) -> Dictionary:
	var dicionario:Dictionary = {}
	for edicao in DATA.UserData[usuario]["informcoes_do_jogador"]["colecao"]:
		dicionario[edicao] = []
		for idx in DATA.UserData[usuario]["informcoes_do_jogador"]["colecao"][edicao]:
			dicionario[edicao].append(int(idx))
	return dicionario

func verificar_e_criar_sala_de_lobby(id:int, user:String) -> void:
	var usuario_real = get_parent().iniciando.aplicar_regra_hash_de_usuario(user)
	CONLOB.criar_ou_gerenciar_lobby(id, usuario_real)
	if CONLOB.jogadores_conectados.has(usuario_real):
		if CONLOB.jogadores_conectados[usuario_real].has(id):
			if CONLOB.jogadores_conectados[usuario_real][id]["status"] == "em_espera":
				get_parent().enviando.jogador_em_fila_de_espera(id)

func verificar_e_sair_da_sala_de_lobby(id:int, user:String) -> void:
	var usuario_real = get_parent().iniciando.aplicar_regra_hash_de_usuario(user)
	if CONLOB.jogadores_conectados.has(usuario_real):
		if CONLOB.jogadores_conectados[usuario_real].has(id):
			if CONLOB.jogadores_conectados[usuario_real][id]["status"] == "em_espera":
				CONLOB.sair_da_espera(id, usuario_real)
	
	if CONLOB.jogadores_conectados.has(usuario_real):
		if CONLOB.jogadores_conectados[usuario_real].has(id):
			if CONLOB.jogadores_conectados[usuario_real][id]["status"] == "conectado":
				get_parent().enviando.jogador_saiu_da_fila(id)

func verificar_se_jogadores_prontos(peer_id:int) -> void:
	var sala_em_verificacao:String = ""
	for sala in CONLOB.lobbys_em_partidas:
		for id in CONLOB.lobbys_em_partidas[sala]:
			if int(id) == int(peer_id):
				sala_em_verificacao = sala
				if CONLOB.lobbys_em_partidas[sala][id]["inicio_da_partida"] == false:
					CONLOB.lobbys_em_partidas[sala][id]["inicio_da_partida"] = true
	
	var verificado:bool = false
	for id in CONLOB.lobbys_em_partidas[sala_em_verificacao]:
		if CONLOB.lobbys_em_partidas[sala_em_verificacao][id]["inicio_da_partida"] == true:
			verificado = true
	
	if verificado:
		get_parent().enviando.liberar_inicio_de_partida(peer_id, sala_em_verificacao)

func informacoes_de_inicio_de_partida(id:int, dicionario:Dictionary, sala:String) -> void:
	if CONLOB.lobbys_em_partidas[sala][id].has("heroi"):
		return
	if CONLOB.lobbys_em_partidas[sala][id].has("voto"):
		return

	CONLOB.lobbys_em_partidas[sala][id]["voto"] = dicionario[id][0]
	CONLOB.lobbys_em_partidas[sala][id]["heroi"] = dicionario[id][1]
	
	var voto_e_heroi:bool = true
	for player in CONLOB.lobbys_em_partidas[sala]:
		if typeof(player) == 2:
			if !CONLOB.lobbys_em_partidas[sala][player].has("heroi") && !CONLOB.lobbys_em_partidas[sala][player].has("voto"):
				voto_e_heroi = false
		
	if voto_e_heroi:
		get_parent().enviando.descobrir_racas_mais_votadas_para_banimento(sala)

func inicializacao_de_taverna(sala:String, id:int) -> void:
	if CONLOB.infomacoes_de_partidas[sala]["jogadores"][id].has("taverna"):
		var cartas_antigas:Array = CONLOB.infomacoes_de_partidas[sala]["jogadores"][id]["taverna"]["cartas_exibidas"]
		for edicao in cartas_antigas:
			for carta in cartas_antigas[edicao]:
				CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_disponiveis"].append(carta)
		CONLOB.infomacoes_de_partidas[sala]["jogadores"][id]["taverna"]["cartas_exibidas"] = cavar_cartas_da_pool(sala, id)
	else:
		CONLOB.infomacoes_de_partidas[sala]["jogadores"][id]["taverna"] = {}
		CONLOB.infomacoes_de_partidas[sala]["jogadores"][id]["taverna"]["tier"] = "TIER_0"
		CONLOB.infomacoes_de_partidas[sala]["jogadores"][id]["taverna"]["cartas_exibidas"] = cavar_cartas_da_pool(sala, id)
		CONLOB.infomacoes_de_partidas[sala]["jogadores"][id]["taverna"]["congelada"] = false
	
	get_parent().enviando.informacoes_atualizadas(sala)

func cavar_cartas_da_pool(sala:String, id:int):
	randomize()
	entrar_na_fila_de_compra(id)
	if fila_de_compra[0] == id:
		fila_de_compra.erase(id)
		var edicoes:Array
		for edicao in CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_disponiveis"]:
			CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_disponiveis"][edicao].shuffle()
			edicoes.append(edicao)
		var cartas_cavadas:Dictionary = {}
		for x in range(4):
			var edicao_selecionada:String = edicoes.pick_random()
			var carta_selecionada:int = CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_disponiveis"][edicao_selecionada][randi_range(0,CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_disponiveis"][edicao_selecionada].size() - 1)]
			if carta_valida(CONLOB.infomacoes_de_partidas[sala]["jogadores"][id]["taverna"]["tier"], edicao_selecionada, carta_selecionada):
				CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_disponiveis"][edicao_selecionada].erase(carta_selecionada)
				if !cartas_cavadas.has(edicao_selecionada):
					cartas_cavadas[edicao_selecionada] = []
				cartas_cavadas[edicao_selecionada].append(carta_selecionada)
			else:
				for edicao in CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_disponiveis"]:
					for carta in CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_disponiveis"][edicao]:
						if DATA.Carta_info[edicao][str(carta)]["Tier"] == CONLOB.infomacoes_de_partidas[sala]["jogadores"][id]["taverna"]["tier"]:
							edicao_selecionada = edicao
							carta_selecionada = carta
							break
					break
				
				CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_disponiveis"][edicao_selecionada].erase(carta_selecionada)
				if !cartas_cavadas.has(edicao_selecionada):
					cartas_cavadas[edicao_selecionada] = []
				cartas_cavadas[edicao_selecionada].append(carta_selecionada)
		
		return cartas_cavadas
	else:
		cavar_cartas_da_pool(sala, id)

func carta_valida(tier:String, edicao:String, carta_id:int) -> bool:
	var valor_1:int = 0
	var valor_2:int = 0
	match tier:
		"TIER_0":
			valor_1 = 0
		"TIER_1":
			valor_1 = 1
		"TIER_2":
			valor_1 = 2
		"TIER_3":
			valor_1 = 3
	
	match DATA.Carta_info[edicao][str(carta_id)]["Tier"]:
		"TIER_0":
			valor_2 = 0
		"TIER_1":
			valor_2 = 1
		"TIER_2":
			valor_2 = 2
		"TIER_3":
			valor_2 = 3
	
	if valor_1 >= valor_2:
		return true
	else:
		return false


func entrar_na_fila_de_compra(id:int) -> void:
	if fila_de_compra.has(id):
		return
	fila_de_compra.append(id)

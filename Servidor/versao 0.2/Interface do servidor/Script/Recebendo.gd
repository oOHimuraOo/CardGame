class_name RECEBENDO
extends Node

var testador:Dictionary = {0: "TYPE_NIL", 1: "TYPE_BOOL", 2: "TYPE_INT", 3: "TYPE_FLOAT", 4: "TYPE_STRING", 5:"TYPE_VECTOR2", 6: "TYPE_VECTOR2I", 7: "TYPE_RECT2", 8: "TYPE_RECT2I", 9: "TYPE_VECTOR3", 10: "TYPE_VECTOR3I", 11: "TYPE_TRANSFORM2D", 12: "TYPE_VECTOR4", 13: "TYPE_VECTOR4I",14: "TYPE_PLANE", 15: "TYPE_QUATERNION", 16:"TYPE_AABB", 17:"TYPE_BASIS", 18:"TYPE_TRANSFORM3D", 19:"TYPE_PROJECTION", 20:"TYPE_COLOR", 21:"TYPE_STRING_NAME", 22:"TYPE_NODE_PATH", 23:"TYPE_RID", 24:"TYPE_OBJECT", 25:"TYPE_CALLABLE", 26:"TYPE_SIGNAL", 27:"TYPE_DICTIONARY", 28:"TYPE_ARRAY", 29:"TYPE_PACKED_BYTE_ARRAY", 30:"TYPE_PACKED_INT32_ARRAY", 31:"TYPE_PACKED_INT64_ARRAY", 32:"TYPE_PACKED_FLOAT32_ARRAY", 33:"TYPE_PACKED_FLOAT64_ARRAY", 34:"TYPE_PACKED_STRING_ARRAY", 35: "TYPE_PACKED_VECTOR2_ARRAY", 36:"TYPE_PACKED_VECTOR3_ARRAY", 37:"TYPE_PACKED_COLOR_ARRAY", 38:"TYPE_MAX"}

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

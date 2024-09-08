class_name INICIANDO
extends Node


func autenticar_usuario_e_senha(usuario:String, senha:String, verificador:bool, id:int) -> void:
	var novo_usuario: String = aplicar_regra_hash_de_usuario(usuario)
	var novo_senha: String = aplicar_regra_hash_de_senha(senha)
	if DATA.UserData.has(novo_usuario):
		if DATA.UserData[novo_usuario]["senha"] == novo_senha:
			get_parent().enviando.servidor_client_usuario_autenticado(true, verificador, id, usuario, senha)
			CONLOB.adicionar_ou_atualizar_jogador_conectado(id, novo_usuario,"conectado")
			return
	get_parent().enviando.servidor_client_usuario_autenticado(false, verificador, id)
	

func aplicar_regra_hash_de_usuario(valor:String) -> String:
	var converter:String = ""
	for x in range(valor.length()):
		for idx in DATA.RegrasHash["regra0"]:
			if str(DATA.RegrasHash["regra0"][idx]["letra"]) == str(valor[x]):
				converter += str(DATA.RegrasHash["regra0"][idx]["novo_valor"])
	
	var identificador_1:int = 0
	for x in range(converter.length()):
		for idx in DATA.RegrasHash["regra1"]:
			if DATA.RegrasHash["regra1"][idx]["letra"] == str(converter[x]):
				identificador_1 += DATA.RegrasHash["regra1"][idx]["novo_valor"]
	
	var identificador_2:String = ""
	if identificador_1 > 59:
		identificador_1 = identificador_1 - 59
	
	var palavra_1 = DATA.RegrasHash["regra2"][str(identificador_1)]["palavra_1"]
	var palavra_2 = DATA.RegrasHash["regra2"][str(identificador_1)]["palavra_2"]
	identificador_2 = palavra_1 + palavra_2
	
	var nova_hash: String = str(identificador_1) + "#" + converter + "#" + identificador_2
	return nova_hash

func aplicar_regra_hash_de_senha(valor:String) -> String:
	var novo_valor: String = str(valor.hash())
	return novo_valor

func criar_usuario(usuario:String, senha:String, email:String, nick:String, id:int) -> void:
	var novo_usuario:String = aplicar_regra_hash_de_usuario(usuario)
	var novo_senha:String = aplicar_regra_hash_de_senha(senha)
	if DATA.UserData.has(novo_usuario):
		get_parent().enviando.servidor_client_falha_ao_criar_cadastro(id)
		return
	
	var nova_informacao: Dictionary = {
		"senha": novo_senha,
		"email": email,
		"informcoes_do_jogador": {
			"nick": nick,
			"rank": 0,
			"level": 0,
			"exp_atual": 0,
			"exp_proximo_nivel": 100,
			"gold": 0,
			"packs": {
				"edicao_0":{
					"quantidade": 30
				},
				"edicao_1":{
					"quantidade": 30
				}
			},
			"racas_banidas": {
				"mortoVivo": 0,
				"besta": 0,
				"dragao": 0,
				"naga": 0,
				"elemental": 0,
				"pirata": 0,
				"elfo": 0,
				"anao": 0,
				"metamorfo": 0,
				"humano": 0
			},
			"decks_do_jogador":{
				"mortoVivo_base": {
					"cartas": {
						"edicao_0": [0, 0, 0, 0, 0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
						},
					"nome": "mortoVivo_base",
					"raca": "Morto-Vivo",
					"imagem": "res://icon.svg"
				}, 
				"besta_base":{
					"cartas": {
						"edicao_0": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
						},
					"nome": "besta_base",
					"raca": "Besta",
					"imagem": "res://icon.svg"
				}, 
				"dragao_base":{
					"cartas": {
						"edicao_0": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
						},
					"nome": "dragao_base",
					"raca": "Dragao",
					"imagem": "res://icon.svg"
				}, 
				"naga_base":{
					"cartas": {
						"edicao_0": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
						},
					"nome": "naga_base",
					"raca": "Naga",
					"imagem": "res://icon.svg"
				}, 
				"elemental_base":{
					"cartas": {
						"edicao_0": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
						},
					"nome": "elemental_base",
					"raca": "Elemental",
					"imagem": "res://icon.svg"
				}, 
				"pirata_base":{
					"cartas": {
						"edicao_0": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
						},
					"nome": "pirata_base",
					"raca": "Pirata",
					"imagem": "res://icon.svg"
				}, 
				"elfo_base":{
					"cartas": {
						"edicao_0": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
						},
					"nome": "elfo_base",
					"raca": "Elfo",
					"imagem": "res://icon.svg"
				}, 
				"anao_base":{
					"cartas": {
						"edicao_0": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
						},
					"nome": "anao_base",
					"raca": "Anao",
					"imagem": "res://icon.svg"
				}, 
				"metamorfo_base":{
					"cartas": {
						"edicao_0": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
						},
					"nome": "metamorfo_base",
					"raca": "Metamorfo",
					"imagem": "res://icon.svg"
				}, 
				"humano_base":{
					"cartas": {
						"edicao_0": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
						},
					"nome": "humano_base",
					"raca": "Humano",
					"imagem": "res://icon.svg"
				} 
			},
			"registro_de_partidas": {
				"partida_0": {
					"heroi": "nome do heroi",
					"vitoria": null,
					"data": "09:47 | 19/08/2024"
				},
				"partida_1 ": {
					"heroi": "nome do heroi",
					"vitoria": null,
					"data": "09:47 | 19/08/2024"
				},
				"partida_2": {
					"heroi": "nome do heroi",
					"vitoria": null,
					"data": "09:47 | 19/08/2024"
				}
			},
			"registro_de_herois": {
				"heroi_1": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_2": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_3": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_4": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_5": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_6": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_7": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_8": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_9": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_10": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_11": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_12": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_13": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_14": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
				"heroi_15": {
					"partidas_jogada": 0,
					"vitorias": 0,
					"derrotas": 0,
				},
			},
			"colecao": {
				"edicao_0": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 181, 182, 183, 184, 185, 186, 187, 188, 189]
				}
		}
	}
	
	DATA.registrar_nova_informação_em_user_data(novo_usuario, nova_informacao)
	get_parent().enviando.servidor_client_sucesso_ao_criar_cadastro(id)

class_name RECEBENDO
extends Node

var testador:Dictionary = {0: "TYPE_NIL", 1: "TYPE_BOOL", 2: "TYPE_INT", 3: "TYPE_FLOAT", 4: "TYPE_STRING", 5:"TYPE_VECTOR2", 6: "TYPE_VECTOR2I", 7: "TYPE_RECT2", 8: "TYPE_RECT2I", 9: "TYPE_VECTOR3", 10: "TYPE_VECTOR3I", 11: "TYPE_TRANSFORM2D", 12: "TYPE_VECTOR4", 13: "TYPE_VECTOR4I",14: "TYPE_PLANE", 15: "TYPE_QUATERNION", 16:"TYPE_AABB", 17:"TYPE_BASIS", 18:"TYPE_TRANSFORM3D", 19:"TYPE_PROJECTION", 20:"TYPE_COLOR", 21:"TYPE_STRING_NAME", 22:"TYPE_NODE_PATH", 23:"TYPE_RID", 24:"TYPE_OBJECT", 25:"TYPE_CALLABLE", 26:"TYPE_SIGNAL", 27:"TYPE_DICTIONARY", 28:"TYPE_ARRAY", 29:"TYPE_PACKED_BYTE_ARRAY", 30:"TYPE_PACKED_INT32_ARRAY", 31:"TYPE_PACKED_INT64_ARRAY", 32:"TYPE_PACKED_FLOAT32_ARRAY", 33:"TYPE_PACKED_FLOAT64_ARRAY", 34:"TYPE_PACKED_STRING_ARRAY", 35: "TYPE_PACKED_VECTOR2_ARRAY", 36:"TYPE_PACKED_VECTOR3_ARRAY", 37:"TYPE_PACKED_COLOR_ARRAY", 38:"TYPE_MAX"}

func verificar_possibilidade_de_deck_list(deck_list:Dictionary, raca:String, client:String, id:int) -> void:
	var usuario_real:String = get_parent().iniciando.aplicar_regra_hash_de_usuario(client)
	var novo_deck:Dictionary = converter_modelo_de_dicionario_de_deck_para_modelo_padrao(deck_list)
	var count:int = 0
	
	var verificacao_de_tamanho:bool = false
	var verificacao_de_repeticao:bool = false
	var verificacao_de_carta:bool = false
	
	for edicao in novo_deck:
		for x in range(novo_deck[edicao].size()):
			count += 1
	
	if count == 15:
		verificacao_de_tamanho = true
	
	for edicao in novo_deck:
		for idx in novo_deck[edicao]:
			if DATA.UserData[usuario_real]["informcoes_do_jogador"]["colecao"][edicao].has(idx):
				verificacao_de_carta = true
			else:
				verificacao_de_carta = false
	
	if verificacao_de_carta:
		for edicao in novo_deck:
			for idx in novo_deck[edicao]:
				if novo_deck[edicao].count(idx) == DATA.UserData[usuario_real]["informcoes_do_jogador"]["colecao"][edicao].count(idx):
					verificacao_de_repeticao = true
				else:
					verificacao_de_repeticao = false
	
	if !verificacao_de_tamanho:
		var msg:String = "Baralho nao atualizado! \nTamanho de deck invalido: Erro 001!"
		get_parent().enviando.finalizando_alteracao_de_deck(id, false, msg)
		return
	
	if !verificacao_de_carta:
		var msg:String = "Baralho nao atualizado! \nCarta nao existente na colecao: Erro 002!"
		get_parent().enviando.finalizando_alteracao_de_deck(id, false, msg)
		return
	
	if !verificacao_de_repeticao:
		var msg:String = "Baralho nao atualizado! \nQuantidade de cartas invalida: Erro 003!"
		get_parent().enviando.finalizando_alteracao_de_deck(id, false, msg)
		return
	
	var msg:String = "Baralho atualizado com sucesso!"
	DATA.atualizar_deck(usuario_real, deck_list, raca)
	get_parent().enviando.finalizando_alteracao_de_deck(id, true, msg)
	
	
	#var count:int = 0
	#for edicao in deck_list:
		#for index in deck_list[edicao]:
			#var array_temp:Array = DATA.UserData[usuario_real]["informcoes_do_jogador"]["colecao"][edicao].duplicate(true)
			#for x in range(array_temp.size()):
				#array_temp[x] = float(array_temp[x])
			#index = float(index)
			#if array_temp.has(index):
				#if array_temp.count(index) >= deck_list[edicao][index]["quantidade"]:
					#print("a")
					#count += 1
				#else:
					#print("b")
					#count -= 1
			#else:
				#count = 1000
	#
			#print("a contagem está em: ", count, "\nO array é : ", array_temp, "\nO index é: ", index, "\nO tipo do index é: ", testador[typeof(index)], "\nO index aparece: ", array_temp.count(index), " vezes | o valor recebido espera que tenha pelo menos: ", deck_list[edicao][index]["quantidade"], "\nO tipo do valor recebido é: ", testador[typeof(array_temp[array_temp.find(index)])], "\nO array possui o index? ", array_temp.has(index), "\nO index aparece no minimo a quantidade de vezes esperada? ", array_temp.count(index) >= deck_list[edicao][index]["quantidade"], "\nO array de bytes do index é: ", var_to_bytes(index), "\nO array de bytes do valor recebido é: ", var_to_bytes(array_temp[array_temp.find(index)]))
		#
	#if count < 15:
		#var msg:String = "Baralho nao atualizado! \nCarta invalida: Erro 001!"
		#get_parent().enviando.finalizando_alteracao_de_deck(id, false, msg)
	#elif count > 15:
		#var msg:String = "Baralho nao atualizado! \nQuantidade de cartas invalida: Erro 002!"
		#get_parent().enviando.finalizando_alteracao_de_deck(id, false, msg)
	#else:
		#var msg:String = "Baralho atualizado com sucesso!"
		#DATA.atualizar_deck(usuario_real, deck_list, raca)
		#get_parent().enviando.finalizando_alteracao_de_deck(id, true, msg)

func converter_modelo_de_dicionario_de_deck_para_modelo_padrao(deck_list:Dictionary) -> Dictionary:
	var dicionario:Dictionary = {}
	for edicao in deck_list:
		dicionario[edicao] = []
		for index in deck_list[edicao]:
			for x in range(deck_list[edicao][index]["quantidade"]):
				dicionario[edicao].append(index)
	return dicionario
	

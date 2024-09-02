class_name BANCO_DE_DADOS
extends Node

var RegrasHash: Dictionary = {}
var UserData: Dictionary = {}
var NoticiasInfor: Dictionary = {}
var EdicaoTamanhos: Dictionary = {}

func _ready():
	var ler_regras_hash = FileAccess.open("res://Banco de dados/JSON/Not_Heartstone_Regras_Hash.json", FileAccess.READ)
	RegrasHash = JSON.parse_string(ler_regras_hash.get_as_text())
	
	var ler_edicao_tamanhos = FileAccess.open("res://Banco de dados/JSON/Edicao_tamanhos.json", FileAccess.READ)
	EdicaoTamanhos = JSON.parse_string(ler_edicao_tamanhos.get_as_text())
	
	atualizar_noticias()
	#var ler_noticias = FileAccess.open("res://Banco de dados/JSON/Noticias_info.json", FileAccess.READ)
	#NoticiasInfor = JSON.parse_string(ler_noticias.get_as_text())
	
	if FileAccess.file_exists("res://Banco de dados/JSON/User_data.json"):
		atualizar_user_data()

func registrar_nova_informação_em_user_data(novo_usuario:String, nova_informacao:Dictionary) -> void:
	UserData[novo_usuario] = nova_informacao
	var ler_user_data = FileAccess.open("res://Banco de dados/JSON/User_data.json", FileAccess.WRITE)
	ler_user_data.store_string(JSON.stringify(UserData,"	", false)) 
	ler_user_data.close()
	
	atualizar_user_data()

func atualizar_user_data() -> void:
	var ler_user_data = FileAccess.open("res://Banco de dados/JSON/User_data.json", FileAccess.READ)
	UserData = JSON.parse_string(ler_user_data.get_as_text())

func atualizar_noticias() -> void:
	if FileAccess.file_exists("res://Banco de dados/JSON/Noticias_info.json"):
		var ler_noticias = FileAccess.open("res://Banco de dados/JSON/Noticias_info.json", FileAccess.READ)
		NoticiasInfor = JSON.parse_string(ler_noticias.get_as_text())
	
	if NoticiasInfor.has(Time.get_date_string_from_system()):
		return
	
	DirAccess.remove_absolute("res://Banco de dados/JSON/Noticias_info.json")
	var escrever_noticias = FileAccess.open("res://Banco de dados/JSON/Noticias_info.json", FileAccess.WRITE)
	
	var noticias: Dictionary = {
		Time.get_date_string_from_system(): {
			"carrossel": coletar_informacoes_do_carrossel(),
			"imagem_auxiliar_1": coletar_informacao_auxiliar(1),
			"imagem_auxiliar_2": coletar_informacao_auxiliar(2),
			"imagem_auxiliar_3": coletar_informacao_auxiliar(3)
		}
	}
	
	escrever_noticias.store_string(JSON.stringify(noticias, "	", false))
	escrever_noticias.close()
	
	atualizar_noticias()
	#Essa função precisa verificar se a data registrada no noticias_info é a mesma
	#que a atual.
	# se for ela não faz nada
	# se não for a mesma ela precisará apagar o arquivo atual, criar um arquivo novo
	# e atualizar a informação na variavel noticias.

func coletar_informacoes_do_carrossel() -> Dictionary:
	var carrossel: Dictionary = {}
	for x in range(3):
		carrossel[str(x)] = {
			"img": "res://icon.svg",
			"titulo": "titulo da imagem " + str(x),
			"link": "link de redicionamento",
			"texto": "texto da imagem " + str(x) + " | em: " + Time.get_date_string_from_system() 
			}
	return carrossel

func coletar_informacao_auxiliar(index:int) -> Dictionary:
	var auxiliar: Dictionary = {
		"img": "res://icon.svg",
		"titulo": "titulo da imagem" + str(index),
		"texto": "texto da imagem auxiliar " + str(index) + " | em: " + Time.get_date_string_from_system(),
		"link": "link da imagem",
	}
	return auxiliar
	
func salvar_user_info() -> void:
	var ler_user_info = FileAccess.open("res://Banco de dados/JSON/User_data.json",FileAccess.READ)
	var comparador = JSON.parse_string(ler_user_info.get_as_text())
	
	if UserData == comparador:
		return
	
	DirAccess.remove_absolute("res://Banco de dados/JSON/User_data.json")
	var escrever_user_info = FileAccess.open("res://Banco de dados/JSON/User_data.json", FileAccess.WRITE)
	escrever_user_info.store_string(JSON.stringify(UserData, "	", false))

func atualizar_deck(usuario:String, deck_list:Dictionary, raca:String) -> void:
	var nome_do_deck:String
	for deck in UserData[usuario]["informcoes_do_jogador"]["decks_do_jogador"]:
		if UserData[usuario]["informcoes_do_jogador"]["decks_do_jogador"][deck]["raca"] == raca:
			nome_do_deck = deck
	
	for edicao in deck_list:
		UserData[usuario]["informcoes_do_jogador"]["decks_do_jogador"][nome_do_deck]["cartas"][edicao].clear()
		for index in deck_list[edicao]:
			for x in range(deck_list[edicao][index]["quantidade"]):
				UserData[usuario]["informcoes_do_jogador"]["decks_do_jogador"][nome_do_deck]["cartas"][edicao].append(int(index))
	
			print(UserData[usuario]["informcoes_do_jogador"]["decks_do_jogador"][nome_do_deck]["cartas"][edicao])
	salvar_user_info()
	atualizar_user_data()

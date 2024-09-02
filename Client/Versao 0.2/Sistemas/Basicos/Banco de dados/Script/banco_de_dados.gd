class_name BANCO_DE_DADOS
extends Node

signal noticias_atualizadas()

var CardInfo: Dictionary = {}
var HeroiInfo: Dictionary = {}
var loginAutomatico: Dictionary = {}
var NoticiasInfo:Dictionary = {}

func _ready():
	var ler_data_card = FileAccess.open("res://Sistemas/Basicos/Banco de dados/JSON/DATA_CardInfo.json", FileAccess.READ)
	CardInfo = JSON.parse_string(ler_data_card.get_as_text())
	
	var ler_data_heroi = FileAccess.open("res://Sistemas/Basicos/Banco de dados/JSON/DATA_HeroisInfo.json", FileAccess.READ)
	HeroiInfo = JSON.parse_string(ler_data_heroi.get_as_text())
	
	if FileAccess.file_exists("res://Sistemas/Basicos/Banco de dados/JSON/DATA_noticias_info.json"):
		carregar_noticias()
	
	if FileAccess.file_exists("res://Sistemas/Basicos/Banco de dados/JSON/DATA_login_automatico.json"):
		var ler_login_automatico = FileAccess.open("res://Sistemas/Basicos/Banco de dados/JSON/DATA_login_automatico.json", FileAccess.READ)
		loginAutomatico = JSON.parse_string(ler_login_automatico.get_as_text())

func login_automatico(usuario:String, senha:String, verificador:bool) -> void:
	var escrever_info = FileAccess.open("res://Sistemas/Basicos/Banco de dados/JSON/DATA_login_automatico.json", FileAccess.WRITE)
	var info:Dictionary = {"usuario": usuario, "senha": senha, "verificador": verificador}
	escrever_info.store_string(JSON.stringify(info,"",false))
	escrever_info.close()

func excluir_login_automatico() -> void:
	if FileAccess.file_exists("res://Sistemas/Basicos/Banco de dados/JSON/DATA_login_automatico.json"):
		DirAccess.remove_absolute("res://Sistemas/Basicos/Banco de dados/JSON/DATA_login_automatico.json")

func criar_noticias(noticias_info:Dictionary) -> void:
	if FileAccess.file_exists("res://Sistemas/Basicos/Banco de dados/JSON/DATA_noticias_info.json"):
		DirAccess.remove_absolute("res://Sistemas/Basicos/Banco de dados/JSON/DATA_noticias_info.json")
	var escrever_info = FileAccess.open("res://Sistemas/Basicos/Banco de dados/JSON/DATA_noticias_info.json", FileAccess.WRITE)
	escrever_info.store_string(JSON.stringify(noticias_info, "	", false))
	escrever_info.close()
	
	carregar_noticias()

func carregar_noticias() -> void:
	var ler_noticias = FileAccess.open("res://Sistemas/Basicos/Banco de dados/JSON/DATA_noticias_info.json", FileAccess.READ)
	NoticiasInfo = JSON.parse_string(ler_noticias.get_as_text())
	noticias_atualizadas.emit()

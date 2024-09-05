class_name CATALOGO_DE_CARTAS
extends Node

var catalogo:Dictionary = {}

func gerar_catalogo() -> void:
	catalogo.clear()
	for edicao in DATA.CardInfo:
		catalogo[edicao] = {}
		for idx in DATA.CardInfo[edicao]:
			catalogo[edicao][int(idx)] = {}
			catalogo[edicao][int(idx)]["raca"] = DATA.CardInfo[edicao][str(idx)]["Tipo"]
			catalogo[edicao][int(idx)]["pagina"] = {}
			catalogo[edicao][int(idx)]["pagina"]["colecao"] = int(0)
			catalogo[edicao][int(idx)]["pagina"]["mutavel"] = int(0)
			catalogo[edicao][int(idx)]["possuido"] = false
			catalogo[edicao][int(idx)]["quantidade"] = int(0)
			catalogo[edicao][int(idx)]["em_deck"] = {}

func registrar_posse(colecao:Dictionary) -> void:
	for edicao in colecao:
		for idx in colecao[edicao]:
			catalogo[edicao][int(idx)]["possuido"] = true
			catalogo[edicao][int(idx)]["quantidade"] += 1

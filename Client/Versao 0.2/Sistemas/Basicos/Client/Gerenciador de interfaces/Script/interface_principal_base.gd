class_name INTERFACE_PRINCIPAL_BASE
extends INTERFACE_PRINCIPAL_REFERENCIAS

signal info_recebida()

var AccountInfo: Dictionary = {}

func carregar_informacoes() -> void:
	if AccountInfo.is_empty():
		SERVER.enviando.solicitar_informacao_de_jogador_pro_server(get_tree().get_first_node_in_group("Client").name)
	
	await info_recebida
	#var caminho_textura:String = "caminho_padrao" + "inicio_de_nome" + str(AccountInfo["rank"]) + ".formato"
	#imagem_rank.set_texture(load(caminho_textura))
	etiqueta_gold.set_text(str(AccountInfo["gold"]))
	var packs_totais:int = 0
	for edicao in AccountInfo["packs"]:
		packs_totais += int(AccountInfo["packs"][edicao]["quantidade"])
	etiqueta_pack.set_text(str(packs_totais))
	etiqueta_level.set_text(str(AccountInfo["level"]))
	pagina_profile.atualizar_informacoes(AccountInfo)
	pagina_decks.atualizar_informacoes(AccountInfo)
	pagina_packs.atualizar_informacoes(AccountInfo)

func atualizar_informacoes() -> void:
	AccountInfo.clear()
	carregar_informacoes()

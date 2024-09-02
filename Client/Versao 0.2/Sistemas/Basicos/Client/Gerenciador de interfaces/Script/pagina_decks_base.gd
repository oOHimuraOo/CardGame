class_name PAGINA_DECKS_BASE
extends PAGINA_DECKS_REFERENCIAS

func atualizar_informacoes(account_info:Dictionary) -> void:
	instanciar_decks(account_info["decks_do_jogador"])

func instanciar_decks(decks_info:Dictionary) -> void:
	for info in decks_info:
		var deck_instancia:BORDA_DECK = borda_deck_cena.instantiate()
		deck_instancia.name = info
		deck_instancia.cartas_no_deck = decks_info[info]["cartas"]
		organizador_em_grid.add_child(deck_instancia)
		deck_instancia.imagem_deck.set_texture(load(decks_info[info]["imagem"]))
		#var caminho_textura = "caminho_base" + "inicio_nome" + decks_info[info]["raca"] + ".formato"
		#deck_instancia.imagem_raca.set_texture(load(caminho_textura))
		deck_instancia.etiqueta_nome_deck.set_text(info)
		deck_instancia.deck_selecionado.connect(abrir_editor)

func abrir_editor(nome_do_deck:String) -> void:
	var construtor_instancias:CONSTRUTOR_DE_DECK_BASE = CONS.CONSTRUTOR_DE_DECK_CENA.instantiate()
	get_tree().root.add_child(construtor_instancias)
	SERVER.enviando.solicitar_colecao_ao_servidor()
	SERVER.enviando.solicitar_deck_ao_servidor(nome_do_deck)


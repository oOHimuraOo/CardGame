class_name PAGINA_PROFILE_BASE
extends PAGINA_PROFILE_REFERENCIAS


func atualizar_informacoes(acount_info:Dictionary) -> void:
	#var caminho_textura = "caminho_base" + "inicio_de_nome" + str(acount_info["rank"]) + ".formato"
	#imagem_rank.set_texture(caminho_textura)
	etiqueta_nick_jogador.set_text(acount_info["nick"])
	instanciar_info_herois(acount_info)
	instanciar_info_racas(acount_info)

func instanciar_info_herois(acount_info:Dictionary) -> void:
	if organizador_de_desempenho.get_child_count() == 0:
		for heroi in lista_de_herois:
			var heroi_instancia = borda_heroi_cena.instantiate()
			heroi_instancia.name = heroi
			organizador_de_desempenho.add_child(heroi_instancia)
			#var caminho_textura = "caminho_base" + heroi + ".formato"
			#heroi_instancia.imagem_heroi.set_texture(load(caminho_textura))
			heroi_instancia.etiqueta_nome.set_text(heroi)
			heroi_instancia.etiqueta_quantidade_partidas.set_text(str(acount_info["registro_de_herois"][heroi]["partidas_jogada"]))
			heroi_instancia.etiqueta_quantidade_vitorias.set_text(str(acount_info["registro_de_herois"][heroi]["vitorias"]))
			heroi_instancia.etiqueta_quantidade_derrotas.set_text(str(acount_info["registro_de_herois"][heroi]["derrotas"]))
			heroi_instancia.botao_de_historia_selecionado.connect(carregar_historia)

func instanciar_info_racas(acount_info:Dictionary) -> void:
	if organizador_de_historico.get_child_count() == 0:
		for raca in lista_de_racas:
			var raca_instancia = borda_historico_cena.instantiate()
			raca_instancia.name = raca
			organizador_de_historico.add_child(raca_instancia)
			#var caminho_textura = "caminho_base" + raca + ".formato"
			#raca_instancia.imagem_raca.set_texture(load(caminho_textura))
			raca_instancia.etiqueta_nome.set_text(raca)
			raca_instancia.etiqueta_quantidade_banidas.set_text(str(acount_info["racas_banidas"][raca]))
			raca_instancia.botao_de_historia_selecionado.connect(carregar_historia)

func carregar_historia(nome_da_historia:String) -> void:
	#var caminho_textura = "caminho_base" + nome_da_historia + ".formato"
	#imagem_historia.set_texture(caminho_textura)
	etiqueta_titulo_historia.set_text(nome_da_historia)
	texto_historia.set_text("eu sou a historia do " + nome_da_historia)

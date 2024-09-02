class_name BORDA_HISTORICO_INFO
extends NinePatchRect

signal botao_de_historia_selecionado(nome_do_dono_do_botao:String)

@onready var imagem_raca = $Marginalizador/OrganizadorDeMiolo/ImagemRaca
@onready var etiqueta_nome = $Marginalizador/OrganizadorDeMiolo/EtiquetaNome
@onready var etiqueta_quantidade_banidas = $Marginalizador/OrganizadorDeMiolo/OrganizadorQuantidadeBanidas/EtiquetaQuantidadeBanidas
@onready var botao_historia_selecionada = $Marginalizador/BotaoHistoriaSelecionada


func quando_botao_historia_selecionada_pressionada():
	botao_de_historia_selecionado.emit(etiqueta_nome.get_text())

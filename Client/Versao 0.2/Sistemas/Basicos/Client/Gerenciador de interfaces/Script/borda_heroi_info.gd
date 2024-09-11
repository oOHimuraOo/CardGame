class_name BORDA_HEROI_INFO
extends NinePatchRect

signal botao_de_historia_selecionado(nome_do_dono_do_botao:String)

@onready var imagem_heroi:TextureRect = $Marginalizador/OrganizadorMiolo/ImagemHeroi
@onready var etiqueta_nome:Label = $Marginalizador/OrganizadorMiolo/EtiquetaNome
@onready var etiqueta_quantidade_partidas:Label = $Marginalizador/OrganizadorMiolo/OrganizadorPartidas/EtiquetaQuantidadePartidas
@onready var etiqueta_quantidade_vitorias:Label = $Marginalizador/OrganizadorMiolo/OrganizadorVitorias/EtiquetaQuantidadeVitorias
@onready var etiqueta_quantidade_derrotas:Label = $Marginalizador/OrganizadorMiolo/OrganizadorDerrotas/EtiquetaQuantidadeDerrotas
@onready var botao_selecionador_de_historia:TextureButton = $Marginalizador/BotaoSelecionadorDeHistoria

func _quando_botao_selecionador_de_historia_pressionado():
	botao_de_historia_selecionado.emit(etiqueta_nome.get_text())


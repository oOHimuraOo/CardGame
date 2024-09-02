class_name PAGINA_PROFILE_REFERENCIAS
extends VBoxContainer

@onready var imagem_rank = $OrganizadorMioloProfile/Marginalizador/GeradorDeScroll/OrganizadorVerticalMiolo/OrganizadorCabecario/BordaRank/Marginalizador/ImagemRank
@onready var etiqueta_nick_jogador = $OrganizadorMioloProfile/Marginalizador/GeradorDeScroll/OrganizadorVerticalMiolo/OrganizadorCabecario/EtiquetaNickJogador
@onready var organizador_de_desempenho = $OrganizadorMioloProfile/Marginalizador/GeradorDeScroll/OrganizadorVerticalMiolo/MioloDesempenho/GeradorDeScroll/OrganizadorDeDesempenho
@onready var organizador_de_historico = $OrganizadorMioloProfile/Marginalizador/GeradorDeScroll/OrganizadorVerticalMiolo/OrganizadorMioloHistorico/GeradorDeScroll/OrganizadorDeHistorico
@onready var imagem_historia = $OrganizadorMioloProfile/OrganizadorVisualizadorHistoria/ImagemHistoria
@onready var etiqueta_titulo_historia = $OrganizadorMioloProfile/OrganizadorVisualizadorHistoria/GeradorDeScroll/PlanoDeFundoDoTexto/OrganizadorTexto/EtiquetaTituloHistoria
@onready var texto_historia = $OrganizadorMioloProfile/OrganizadorVisualizadorHistoria/GeradorDeScroll/PlanoDeFundoDoTexto/OrganizadorTexto/TextoHistoria

@export var borda_heroi_cena:PackedScene
@export var borda_historico_cena:PackedScene

var lista_de_herois:Array = ["heroi_1", "heroi_2", "heroi_3", "heroi_4", "heroi_5", "heroi_6", "heroi_7", "heroi_8", "heroi_9", "heroi_10", "heroi_11", "heroi_12", "heroi_13", "heroi_14", "heroi_15"]
var lista_de_racas:Array = ["mortoVivo", "besta", "dragao", "naga", "elemental", "pirata", "elfo", "anao", "metamorfo", "humano"]


class_name SELECIONADOR_DE_HEROI_REFERENCIAS
extends NinePatchRect

@onready var etiqueta_nome:Label = $Marginalizador/OrganizadorDeMiolo/EtiquetaNome
@onready var retrato_heroi:TextureRect = $Marginalizador/OrganizadorDeMiolo/PlanoDeFundoRetrato/Marginalizador/RetratoHeroi

@onready var icone_habilidade_1:TextureRect = $Marginalizador/OrganizadorDeMiolo/OrganizadorHabilidade1/PlanoDeFundoIconeHabilidade1/Marginalizador/IconeHabilidade1
@onready var icone_habilidade_2:TextureRect = $Marginalizador/OrganizadorDeMiolo/OrganizadorHabilidade2/PlanoDeFundoIconeHabilidade2/Marginalizador/IconeHabilidade2

@onready var texto_habilidade_1:RichTextLabel = $Marginalizador/OrganizadorDeMiolo/OrganizadorHabilidade1/TextoHabilidade1
@onready var texto_habilidade_2:RichTextLabel = $Marginalizador/OrganizadorDeMiolo/OrganizadorHabilidade2/TextoHabilidade2

@onready var botao_selecionar_heroi:TextureButton = $Marginalizador/OrganizadorDeMiolo/Centralizador/BotaoSelecionarHeroi

@onready var icone_contador_de_vida:TextureRect = $Marginalizador/OrganizadorDeMiolo/PlanoDeFundoRetrato/Marginalizador/RetratoHeroi/VBoxContainer/HBoxContainer/PlanoDeFundoVida/Marginalizador/IconeContadorDeVida
@onready var etiqueta_contador_de_vida:Label = $Marginalizador/OrganizadorDeMiolo/PlanoDeFundoRetrato/Marginalizador/RetratoHeroi/VBoxContainer/HBoxContainer/PlanoDeFundoVida/Marginalizador/IconeContadorDeVida/EtiquetaContadorDeVida

@onready var icone_contador_de_ataque:TextureRect = $Marginalizador/OrganizadorDeMiolo/PlanoDeFundoRetrato/Marginalizador/RetratoHeroi/VBoxContainer/HBoxContainer/PlanoDeFundoAtaque/Marginalizador/IconeContadorDeAtaque
@onready var etiqueta_contador_de_ataque:Label = $Marginalizador/OrganizadorDeMiolo/PlanoDeFundoRetrato/Marginalizador/RetratoHeroi/VBoxContainer/HBoxContainer/PlanoDeFundoAtaque/Marginalizador/IconeContadorDeAtaque/EtiquetaContadorDeAtaque

@onready var icone_contador_de_escudo:TextureRect = $Marginalizador/OrganizadorDeMiolo/PlanoDeFundoRetrato/Marginalizador/RetratoHeroi/VBoxContainer/HBoxContainer/PlanoDeFundoEscudo/Marginalizador/IconeContadorDeEscudo
@onready var etiqueta_contador_de_escudo:Label = $Marginalizador/OrganizadorDeMiolo/PlanoDeFundoRetrato/Marginalizador/RetratoHeroi/VBoxContainer/HBoxContainer/PlanoDeFundoEscudo/Marginalizador/IconeContadorDeEscudo/EtiquetaContadorDeEscudo


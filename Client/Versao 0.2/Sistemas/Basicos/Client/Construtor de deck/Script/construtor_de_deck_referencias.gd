class_name CONSTRUTOR_DE_DECK_REFERENCIAS
extends Control

@onready var organizador_de_cartas:GridContainer = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas
@onready var botao_voltar:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorBotoes/BotaoVoltar
@onready var botao_avancar:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorBotoes/BotaoAvancar
@onready var selecionador_de_raca_do_deck:OptionButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/BordaCabecalho/Marginalizador/OrganizadorCabecalho/SelecionadorDeRacaDoDeck
@onready var etiqueta_nome_do_deck:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/BordaCabecalho/Marginalizador/OrganizadorCabecalho/EtiquetaNomeDoDeck
@onready var botao_aplicar_mudanca:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/BotaoAplicarMudanca
@onready var organizador_cartas_lista:VBoxContainer = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista
@onready var etiqueta_aplicar_mudanca = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/BotaoAplicarMudanca/EtiquetaAplicarMudanca

@onready var carta_lista:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista
@onready var carta_lista_2:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista2
@onready var carta_lista_3:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista3
@onready var carta_lista_4:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista4
@onready var carta_lista_5:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista5
@onready var carta_lista_6:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista6
@onready var carta_lista_7:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista7
@onready var carta_lista_8:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista8
@onready var carta_lista_9:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista9
@onready var carta_lista_10:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista10
@onready var carta_lista_11:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista11
@onready var carta_lista_12:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista12
@onready var carta_lista_13:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista13
@onready var carta_lista_14:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista14
@onready var carta_lista_15:TextureButton = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/OrganizadorListaDeck/OrganizadorCartasLista/CartaLista15

@onready var carta_slot_1:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot1/CartaSlot1
@onready var carta_slot_2:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot2/CartaSlot2
@onready var carta_slot_3:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot3/CartaSlot3
@onready var carta_slot_4:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot4/CartaSlot4
@onready var carta_slot_5:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot5/CartaSlot5
@onready var carta_slot_6:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot6/CartaSlot6
@onready var carta_slot_7:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot7/CartaSlot7
@onready var carta_slot_8:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot8/CartaSlot8
@onready var carta_slot_9:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot9/CartaSlot9
@onready var carta_slot_10:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot10/CartaSlot10
@onready var carta_slot_11:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot11/CartaSlot11
@onready var carta_slot_12:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot12/CartaSlot12
@onready var carta_slot_13:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot13/CartaSlot13
@onready var carta_slot_14:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot14/CartaSlot14
@onready var carta_slot_15:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot15/CartaSlot15
@onready var carta_slot_16:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot16/CartaSlot16
@onready var carta_slot_17:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot17/CartaSlot17
@onready var carta_slot_18:Control = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot18/CartaSlot18

@onready var etiqueta_carta_slot_1:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot1/EtiquetaSlot1
@onready var etiqueta_carta_slot_2:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot2/EtiquetaSlot2
@onready var etiqueta_carta_slot_3:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot3/EtiquetaSlot3
@onready var etiqueta_carta_slot_4:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot4/EtiquetaSlot4
@onready var etiqueta_carta_slot_5:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot5/EtiquetaSlot5
@onready var etiqueta_carta_slot_6:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot6/EtiquetaSlot6
@onready var etiqueta_carta_slot_7:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot7/EtiquetaSlot7
@onready var etiqueta_carta_slot_8:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot8/EtiquetaSlot8
@onready var etiqueta_carta_slot_9:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot9/EtiquetaSlot9
@onready var etiqueta_carta_slot_10:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot10/EtiquetaSlot10
@onready var etiqueta_carta_slot_11:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot11/EtiquetaSlot11
@onready var etiqueta_carta_slot_12:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot12/EtiquetaSlot12
@onready var etiqueta_carta_slot_13:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot13/EtiquetaSlot13
@onready var etiqueta_carta_slot_14:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot14/EtiquetaSlot14
@onready var etiqueta_carta_slot_15:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot15/EtiquetaSlot15
@onready var etiqueta_carta_slot_16:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot16/EtiquetaSlot16
@onready var etiqueta_carta_slot_17:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot17/EtiquetaSlot17
@onready var etiqueta_carta_slot_18:Label = $BordaPlanoDeFundo/Marginalizador/OrganizadorMiolo/PlanoDeFundoCartas/OrganizadorDeCartas/OrganizadorSlot18/EtiquetaSlot18


var array_de_nomes:Array[String] = ["carta_lista", "carta_lista_2", "carta_lista_3", "carta_lista_4", "carta_lista_5", "carta_lista_6", "carta_lista_7", "carta_lista_8", "carta_lista_9", "carta_lista_10", "carta_lista_11", "carta_lista_12", "carta_lista_13", "carta_lista_14", "carta_lista_15"]
var array_de_slots:Array[String] = ["carta_slot_1", "carta_slot_2", "carta_slot_3", "carta_slot_4", "carta_slot_5", "carta_slot_6", "carta_slot_7", "carta_slot_8", "carta_slot_9", "carta_slot_10", "carta_slot_11", "carta_slot_12", "carta_slot_13", "carta_slot_14", "carta_slot_15", "carta_slot_16", "carta_slot_17", "carta_slot_18"]
var array_de_etiquetas:Array[String] = ["etiqueta_carta_slot_1", "etiqueta_carta_slot_2", "etiqueta_carta_slot_3", "etiqueta_carta_slot_4", "etiqueta_carta_slot_5", "etiqueta_carta_slot_6", "etiqueta_carta_slot_7", "etiqueta_carta_slot_8", "etiqueta_carta_slot_9", "etiqueta_carta_slot_10", "etiqueta_carta_slot_11", "etiqueta_carta_slot_12", "etiqueta_carta_slot_13", "etiqueta_carta_slot_14", "etiqueta_carta_slot_15", "etiqueta_carta_slot_16", "etiqueta_carta_slot_17", "etiqueta_carta_slot_18"]

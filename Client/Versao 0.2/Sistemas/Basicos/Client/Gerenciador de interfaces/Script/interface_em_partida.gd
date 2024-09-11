class_name INTERFACE_EM_PARTIDA
extends INTERFACE_EM_PARTIDA_REFERENCIAS

signal jogadores_prontos()

var sala:String

func esperar_jogadores_prontos() -> void:
	SERVER.enviando.verificar_se_jogadores_prontos()
	await jogadores_prontos
	iniciar_partida()

func iniciar_partida() -> void:
	var inicio_de_partida_instancia = CONS.INICIO_DE_PARTIDA_CENA.instantiate()
	add_child(inicio_de_partida_instancia)
	var array_de_herois:Array = gerar_lista_de_herois()
	inicio_de_partida_instancia.selecionador_de_heroi_1.iniciar_heroi(array_de_herois[0])
	inicio_de_partida_instancia.selecionador_de_heroi_2.iniciar_heroi(array_de_herois[1])
	inicio_de_partida_instancia.selecionador_de_heroi_3.iniciar_heroi(array_de_herois[2])
	inicio_de_partida_instancia.selecionador_de_heroi_4.iniciar_heroi(array_de_herois[3])

func inicializar_primeira_manutencao() -> void:
	print("jujuba!")

func gerar_lista_de_herois() -> Array:
	randomize()
	var array:Array = []
	var nomes:Array = DATA.HeroiInfo.keys()
	for x in range(4):
		var nome = nomes.pick_random()
		array.append(nome)
		nomes.erase(nome)
	
	return array
		

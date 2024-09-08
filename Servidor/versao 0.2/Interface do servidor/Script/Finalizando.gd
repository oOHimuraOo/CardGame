class_name FINALIZANDO
extends Node


func desconectar_peer(id:int) -> void:
	var timer:Timer = Timer.new()
	timer.wait_time = 600
	timer.one_shot = true
	add_child(timer)
	for jogador in CONLOB.jogadores_conectados:
		if CONLOB.jogadores_conectados[jogador].has(id):
			timer.timeout.connect(apagar_usuario_da_lista_atual.bind(id, jogador, timer)) 
	timer.start()

func apagar_usuario_da_lista_atual(id:int, user:String, timer:Timer) -> void:
	if CONLOB.jogadores_conectados.has(user):
		if CONLOB.jogadores_conectados[user].has(id):
			CONLOB.jogadores_conectados.erase(user)
		else:
			print("jogador reconectado!")
			remove_child(timer)
			return
	
	timer.timeout.disconnect(apagar_usuario_da_lista_atual)
	remove_child(timer)


extends Node


func _ready() -> void:
	Global.root = self
	set_up_networking()


#region network boilerplate whatevs

func set_up_networking():
	Network.player_connected.connect(_on_player_connected)
	Network.player_disconnected.connect(_on_player_disconnected)


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("advance"):
		#%Dialogue.request_advance()

func _on_player_connected(player_id: int, _player_info: Dictionary) -> void:
	#TODO: Figure out what _player_info is meant to do, and make it a Class
	if multiplayer.is_server() and not PlayerHolder.has(player_id):
		var player = PlayerHolder.spawn(player_id)
		var player_count : int = get_tree().get_node_count_in_group("Players")
		if player_count == 2:
			ScreenManager.set_screen.rpc("")
			GameHolder.spawn(player_id)
			print("START GAME")
			
			print("got player", player_id, " playercount is ", )


func _on_player_disconnected(player_id: int) -> void:
	if multiplayer.is_server():
		remove_player(player_id)


func remove_player(player_id: int) -> void:
	for player in get_tree().get_nodes_in_group("Players"):
		if player.name.to_int() == player_id:
			player.queue_free()



#endregion

func start_game_singleplayer():
	Global.game_mode = Global.GameMode.SINGLEPLAYER
	GameHolder.spawn(1)
	ScreenManager.set_screen("")
	# TODO add singleplayer mechanics

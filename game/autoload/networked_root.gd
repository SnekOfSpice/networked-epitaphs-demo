extends Node

const DEFAULT_PORT := 6721
var external_ip : String

func _ready() -> void:
	# doesn't work?
	#var upnp := UPNP.new()
	#var discover_result := upnp.discover()
	#
	#if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		#if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			#
			#var map_result_udp = upnp.add_port_mapping(DEFAULT_PORT, DEFAULT_PORT, "godot_udp", "UDP")
			#var map_result_tcp = upnp.add_port_mapping(DEFAULT_PORT, DEFAULT_PORT, "godot_tcp", "TCP")
			#
			#if not map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
				#upnp.add_port_mapping(DEFAULT_PORT, DEFAULT_PORT, "", "UDP")
			#if not map_result_tcp == UPNP.UPNP_RESULT_SUCCESS:
				#upnp.add_port_mapping(DEFAULT_PORT, DEFAULT_PORT, "", "TCP")
	#
	#external_ip = upnp.query_external_address() 
#	
	#upnp.delete_port_mapping(DEFAULT_PORT, "UDP")
	#upnp.delete_port_mapping(DEFAULT_PORT, "TCP")
	
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
	# TODO add singleplayer mechanics

extends Node
class_name NetworkedRoot


func _ready() -> void:
	set_screen("main_menu")
	Global.root = self
	set_up_networking()
	

@rpc("any_peer","call_local")
func set_screen(screen_name : String):
	for screen in %Screens.get_children():
		screen.queue_free()
	
	if screen_name.is_empty():
		%Screens.hide()
		return
	
	var screen : Control = load("res://game/screens/%s.tscn" % screen_name).instantiate()
	%Screens.add_child(screen)
	%Screens.show()

#region network boilerplate whatevs

func set_up_networking():
	Network.player_connected.connect(_on_player_connected)
	Network.player_disconnected.connect(_on_player_disconnected)

	%PlayerSpawner.spawn_function = spawn_player
	%GameSpawner.spawn_function = spawn_game
	


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance"):
		%Dialogue.request_advance()

func _on_player_connected(player_id: int, _player_info: Dictionary) -> void:
	#TODO: Figure out what _player_info is meant to do, and make it a Class
	if multiplayer.is_server() and not get_tree().current_scene.find_child(str(player_id)):
		var player = %PlayerSpawner.spawn(player_id)
		var player_count := %Players.get_child_count()
		if player_count == 2:
			set_screen.rpc("")
			%GameSpawner.spawn(player_id)
			print("START GAME")
			
			print("got player", player_id, " playercount is ", )


func _on_player_disconnected(player_id: int) -> void:
	if multiplayer.is_server():
		remove_player(player_id)


func remove_player(player_id: int) -> void:
	for player in get_tree().get_nodes_in_group("Players"):
		if player.name.to_int() == player_id:
			player.queue_free()



func spawn_player(player_id: int) -> Node3D:
	var player := preload("res://game/player/player.tscn").instantiate()
	player.name = "%s" % player_id
	player.player_id = player_id
	player.add_to_group("Players")
	player.set_multiplayer_authority(player_id)

	return player

#endregion


func spawn_game(player_id) -> Game:
	var game : Game = preload("res://game/main.tscn").instantiate()
	game.set_multiplayer_authority(1)
	return game

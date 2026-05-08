extends Node


var player_count : int:
	get():
		return %Players.get_child_count()


func _ready() -> void:
	%PlayerSpawner.spawn_function = spawn_player

func has(player_id : int) -> bool:
	for player in %Players.get_children():
		if player.player_id == player_id:
			return true
	return false

func spawn(data : Variant = null):
	%PlayerSpawner.spawn(data)
	print("SPAWING PLAYER")

func spawn_player(player_id: int) -> Node3D:
	var player := preload("res://game/player/player.tscn").instantiate()
	player.name = "%s" % player_id
	player.player_id = player_id
	player.add_to_group("Players")
	player.set_multiplayer_authority(player_id)

	return player

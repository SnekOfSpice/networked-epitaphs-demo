extends Node


func _ready() -> void:
	%GameSpawner.spawn_function = spawn_game


func spawn(data : Variant = null):
	%GameSpawner.spawn(data)


func spawn_game(player_id) -> Game:
	var game : Game = preload("res://game/main.tscn").instantiate()
	game.set_multiplayer_authority(1)
	return game

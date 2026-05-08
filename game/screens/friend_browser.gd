extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_refresh()

func _refresh():
	var steam_running := Steam.isSteamRunning()
	%OfflineLabel.visible = not steam_running
	%EntriesContainer.visible = steam_running
	
	if steam_running:
		%PlaceholderLabel.text = str(get_friends_in_lobbies())

func get_friends_in_lobbies() -> Dictionary:
	var results: Dictionary = {}

	for i in range(0, Steam.getFriendCount()):
		var steam_id: int = Steam.getFriendByIndex(i, Steam.FRIEND_FLAG_IMMEDIATE)
		var game_info: Dictionary = Steam.getFriendGamePlayed(steam_id)

		if game_info.is_empty():
			# This friend is not playing a game
			continue
		else:
			# They are playing a game, check if it's the same game as ours
			var app_id: int = game_info['id']
			var lobby = game_info['lobby']

			if app_id != Steam.getAppID() or lobby is String:
				# Either not in this game, or not in a lobby
				continue

			results[steam_id] = lobby
	return results


# Check if a friend is in a lobby
func is_a_friend_still_in_lobby(steam_id: int, lobby_id: int) -> bool:
	var game_info: Dictionary = Steam.getFriendGamePlayed(steam_id)

	if game_info.is_empty():
		return false

	# They are in a game
	var app_id: int = game_info.id
	var lobby = game_info.lobby

	# Return true if they are in the same game and have the same lobby_id
	return app_id == Steam.getAppID() and lobby is int and lobby == lobby_id


func _on_button_pressed() -> void:
	Global.root.set_screen("main_menu")

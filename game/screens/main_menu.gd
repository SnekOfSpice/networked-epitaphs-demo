extends Control
class_name MainMenu


func _ready() -> void:
	%SteamContainer.visible = Steam.isSteamRunning()
	%SteamOfflineLabel.visible = not Steam.isSteamRunning()
	Network.active_network_type = Network.MultiplayerNetworkType.DISABLED

func _on_local_game_button_pressed() -> void:
	Global.root.start_game_singleplayer()


func _on_steam_browse_button_pressed() -> void:
	Network.active_network_type = Network.MultiplayerNetworkType.STEAM
	ScreenManager.set_screen("friend_browser")


func _on_steam_host_button_pressed() -> void:
	Network.active_network_type = Network.MultiplayerNetworkType.STEAM
	ScreenManager.set_screen("")
	Network.become_host()
	

func _on_e_net_host_button_pressed() -> void:
	ScreenManager.set_screen("enet_setup")


func _on_e_net_join_button_pressed() -> void:
	Network.active_network_type = Network.MultiplayerNetworkType.ENET


func _on_options_button_pressed() -> void:
	ScreenManager.set_screen("options", false)

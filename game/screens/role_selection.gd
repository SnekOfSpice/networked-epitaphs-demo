extends Control



var player_id_hacker : int
var player_id_android : int

func _ready() -> void:
	%SingleplayerContainer.visible = Global.game_mode == Global.GameMode.SINGLEPLAYER
	%MultiplayerContainer.visible = Global.game_mode != Global.GameMode.SINGLEPLAYER
	if multiplayer.is_server():
		set_want_role(1, Global.Role.HACKER)
	else:
		set_want_role(multiplayer.get_unique_id(), Global.Role.ANDROID)

@rpc("any_peer", "call_local")
func set_want_role(player_id : int, role : Global.Role):
	var other_player : int
	for player : int in Network.connected_players.keys():
		if player != player_id:
			other_player = player
	
	
	if role == Global.Role.HACKER:
		set_hacker_android(player_id, other_player)
	elif role == Global.Role.ANDROID:
		set_hacker_android(other_player, player_id)

func is_hacker():
	return player_id_hacker == multiplayer.get_unique_id()
func is_android():
	return not is_hacker()


func set_hacker_android(hacker_id : int, android_id : int):
	player_id_hacker = hacker_id
	player_id_android = android_id
	%HackerLabel.text = "YOU" if is_hacker() else "HER"
	%AndroidLabel.text = "YOU" if is_android() else "HER"
	
	var deselected_scale := 0.7
	var duration := 2.0
	
	#size_tween.set_parallel()
	hacker_target_scale = Vector2.ONE * 1.0 if is_hacker()  else Vector2.ONE * deselected_scale
	android_target_scale = Vector2.ONE * 1.0 if is_android()  else Vector2.ONE * deselected_scale
	hacker_target_modulate = Color(Color.WHITE, 1.0) if is_hacker() else  Color(Color.WHITE, 0.4)
	android_target_modulate = Color(Color.WHITE, 1.0) if is_android() else  Color(Color.WHITE, 0.4)
	
	set_ready(Global.Role.ANDROID, false)
	set_ready(Global.Role.HACKER, false)


var hacker_target_modulate := Color.WHITE
var android_target_modulate := Color.WHITE
var hacker_target_scale := Vector2.ONE
var android_target_scale := Vector2.ONE
func _process(delta: float) -> void:
	%TextureHacker.scale = %TextureHacker.scale.move_toward(hacker_target_scale, delta * 0.5)
	%TextureAndroid.scale = %TextureAndroid.scale.move_toward(android_target_scale, delta * 0.5)
	%TextureHacker.modulate = lerp(%TextureHacker.modulate, hacker_target_modulate, delta * 0.2)
	%TextureAndroid.modulate = lerp(%TextureAndroid.modulate, android_target_modulate, delta * 0.2)


func _on_hacker_button_pressed() -> void:
	set_want_role.rpc(multiplayer.get_unique_id(), Global.Role.HACKER)


func _on_android_button_pressed() -> void:
	set_want_role.rpc(multiplayer.get_unique_id(), Global.Role.ANDROID)


func _unhandled_input(event: InputEvent) -> void:
	if (is_hacker() or Global.game_mode == Global.GameMode.SINGLEPLAYER) and event.is_action_pressed("hacker_confirm"):
		set_ready(Global.Role.HACKER, true)
	if (is_android() or Global.game_mode == Global.GameMode.SINGLEPLAYER) and event.is_action_pressed("android_confirm"):
		set_ready(Global.Role.ANDROID, true)


func set_ready(role : Global.Role, status : bool) -> void:
	if role == Global.Role.HACKER:
		%HackerReadyCheckBox.set_pressed_no_signal(status)
	if role == Global.Role.ANDROID:
		%AndroidReadyCheckBox.set_pressed_no_signal(status)
	
	if %HackerReadyCheckBox.button_pressed and %AndroidReadyCheckBox.button_pressed:
		if multiplayer.is_server() or Global.game_mode == Global.GameMode.SINGLEPLAYER:
			Parser.reset_and_start()
			ScreenManager.clear()

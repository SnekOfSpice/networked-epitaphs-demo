extends Control



var player_id_hacker : int
var player_id_android : int

func _ready() -> void:
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

var size_tween : Tween
func set_hacker_android(hacker_id : int, android_id : int):
	%HackerLabel.text = "YOU" if is_hacker else "HER"
	%AndroidLabel.text = "YOU" if is_android else "HER"
	player_id_hacker = hacker_id
	player_id_android = android_id
	
	if size_tween:
		size_tween.kill()
	size_tween = create_tween()
	size_tween.set_parallel()
	size_tween.tween_property(%TextureHacker , "scale", Vector2.ONE * 1.0 if is_hacker()  else Vector2.ONE * 0.7, 2)
	size_tween.tween_property(%TextureAndroid, "scale", Vector2.ONE * 1.0 if is_android() else Vector2.ONE * 0.7, 2)
	size_tween.tween_property(%TextureHacker , "modulate:s", 0.0 if is_hacker()  else 0.7, 2)
	size_tween.tween_property(%TextureAndroid, "modulate:s", 0.0 if is_android() else 0.7, 2)
	
	set_ready(Global.Role.ANDROID, false)
	set_ready(Global.Role.HACKER, false)

func _on_hacker_button_pressed() -> void:
	set_want_role.rpc(multiplayer.get_unique_id(), Global.Role.HACKER)


func _on_android_button_pressed() -> void:
	set_want_role.rpc(multiplayer.get_unique_id(), Global.Role.ANDROID)


func _unhandled_input(event: InputEvent) -> void:
	if is_hacker() and event.is_action_pressed("hacker_confirm"):
		set_ready(Global.Role.HACKER, true)
	if is_android() and event.is_action_pressed("android_confirm"):
		set_ready(Global.Role.ANDROID, true)


func set_ready(role : Global.Role, status : bool) -> void:
	if role == Global.Role.HACKER:
		%HackerReadyCheckBox.set_pressed_no_signal(status)
	if role == Global.Role.ANDROID:
		%AndroidReadyCheckBox.set_pressed_no_signal(status)
	
	if %HackerReadyCheckBox.button_pressed and %AndroidReadyCheckBox.button_pressed:
		print("START GAME")

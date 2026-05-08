extends Control
class_name EnetSetup

func _ready() -> void:
	%HostingBlocker.hide()
	%JoinErrorLabel.modulate.a = 0
	Network.active_network_type = Network.MultiplayerNetworkType.ENET
	var v4_addresses := []
	for address : String in IP.get_local_addresses():
		if address.count(".") == 3:
			if address != "127.0.0.1":
				v4_addresses.append(address)
	print(v4_addresses)
	%CopyIPButton.disabled = true
	if v4_addresses.is_empty():
		%YourIPLabel.text = "No local IP found."
		return
	if v4_addresses.size() > 2:
		%YourIPLabel.text = "Found multiple IP addresses:\n%s" % ",".join(v4_addresses)
		return
	%YourIPLabel.text = str(v4_addresses.front())
	%CopyIPButton.disabled = false


var error_tween : Tween
func _on_ip_text_submitted(new_text: String) -> void:
	if new_text:
		Network.ip_address = new_text
	else:
		Network.ip_address = "localhost"

	var error = Network.join_as_client()
	if error != OK:
		if error_tween:
			error_tween.kill()
		error_tween = create_tween()
		%JoinErrorLabel.modulate.a = 1
		error_tween.tween_property(%JoinErrorLabel, "modulate:a", 0, 2).set_delay(2)


func _on_host_pressed() -> void:
	Network.ip_address = %YourIPLabel.text
	become_host()
func become_host():
	Network.become_host()
	%HostingBlocker.show()
	%HostingAtLabel.text = str(Network.ip_address)
	


func _on_join_pressed() -> void:
	_on_ip_text_submitted(%IP.text)


func _on_back_pressed() -> void:
	Global.root.set_screen("main_menu")


func _on_copy_ip_button_pressed() -> void:
	DisplayServer.clipboard_set(%YourIPLabel.text)


func _on_host_locally_button_pressed() -> void:
	Network.ip_address = "127.0.0.1"
	become_host()

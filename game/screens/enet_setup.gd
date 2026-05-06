extends Control
class_name EnetSetup

func _ready() -> void:
	Network.active_network_type = Network.MultiplayerNetworkType.ENET
	var v4_addresses := []
	for address : String in IP.get_local_addresses():
		if address.count(".") == 3:
			if address != "127.0.0.1":
				v4_addresses.append(address)
	print(v4_addresses)
	$Label.text = "your ips are %s" % str(v4_addresses)


func _on_ip_text_submitted(new_text: String) -> void:
	if new_text:
		Network.ip_address = new_text
	else:
		Network.ip_address = "localhost"

	Network.join_as_client()


func _on_host_pressed() -> void:
	Network.become_host()
	print("WAIT FOR PLAYERS THEN START GAME")

func _on_join_pressed() -> void:
	_on_ip_text_submitted(%IP.text)


func _on_back_pressed() -> void:
	Global.root.set_screen("main_menu")

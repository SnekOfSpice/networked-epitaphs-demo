extends Control


func _ready() -> void:
	set_screen("main_menu")


@rpc("any_peer","call_local")
func set_screen(screen_name : String, clear_previous := true):
	if clear_previous:
		clear()
	
	if screen_name.is_empty():
		hide()
		return
	
	var screen : Control = load("res://game/screens/%s.tscn" % screen_name).instantiate()
	add_child(screen)
	show()

func clear():
	for child in get_children():
		child.queue_free()

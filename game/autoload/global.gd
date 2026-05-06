extends Node


var root : NetworkedRoot


func _ready() -> void:
	# local debug stuff
	var screen : int = DisplayServer.window_get_current_screen(get_window().get_window_id())
	var screen_size : Rect2i = DisplayServer.screen_get_usable_rect(screen)
	if "player0" in OS.get_cmdline_args():
		get_window().size = screen_size.size * 0.5
		get_window().position = screen_size.position
	if "player1" in OS.get_cmdline_args():
		get_window().size = screen_size.size * 0.5
		get_window().position = screen_size.position
		get_window().position.x += int(screen_size.size.x * 0.5)
	if "player2" in OS.get_cmdline_args():
		get_window().size = screen_size.size * 0.5
		get_window().position = screen_size.position
		get_window().position.y += int(screen_size.size.y * 0.5)
		get_window().position.x += int(screen_size.size.x * 0.5)

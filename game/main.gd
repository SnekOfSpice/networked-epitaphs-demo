extends Control
class_name Game

func _ready() -> void:
	%Dialogue.set_process(multiplayer.is_server())
	%Dialogue.set_physics_process(multiplayer.is_server())
	#Parser.reset_and_start()
	
	ScreenManager.set_screen("role_selection")

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("advance"):
		#%Dialogue.request_advance()

func _process(delta: float) -> void:
	$Label.text = str($MarginContainer/RichTextLabel.visible)

func _on_advance_button_pressed() -> void:
	if not multiplayer.is_server():
		return
	%Dialogue.request_advance()


func _on_button_pressed() -> void:
	$Label.text = str(randf())

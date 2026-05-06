@tool
extends LineReader

@export var background : TextureRect

func set_background(key : String):
	background.texture = load("res://game/backgrounds/%s.png" % key)


func end():
	set_background("black")
	body_label.hide()

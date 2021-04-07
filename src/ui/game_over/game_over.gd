extends Control

func _ready():
	var level = get_parent().get_parent()
	level.connect("ui_loaded", self, "show_flavour_text")


func show_flavour_text():
	var flavour_text = $MarginContainer/VBoxContainer/FlavourText/Label
	var flavour_text_tween = $MarginContainer/VBoxContainer/FlavourText/Tween
	flavour_text_tween.interpolate_property(
		flavour_text,
		"modulate",
		Color(0.29, 0.12, 0.13, 0.0),
		Color(0.29, 0.12, 0.13, 1.0),
		3,
		Tween.TRANS_EXPO,
		Tween.EASE_IN_OUT
	)
	flavour_text_tween.start()

func _on_Continue_pressed():
	get_tree().reload_current_scene()


func _on_Quit_pressed():
	get_tree().quit()


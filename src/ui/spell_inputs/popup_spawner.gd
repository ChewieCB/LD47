extends Node2D

onready var timer_popup_scene = load("res://src/ui/timer_popups/TimerPopup.tscn")
onready var spell_ui = get_parent()


func add_popup(seconds):
	var popup_instance = timer_popup_scene.instance()
	self.add_child(popup_instance)
	popup_instance.label.text = "+%s" % [str(seconds)]
	popup_instance.global_position = self.global_position
	popup_instance.animation_player.play("fade_up")


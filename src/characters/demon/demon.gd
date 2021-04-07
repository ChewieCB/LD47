extends Node2D

signal evolved


onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.play("idle")
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "evolve":
		animation_player.play("evolved_idle")
		emit_signal("evolved")


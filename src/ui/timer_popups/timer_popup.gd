extends Node2D

onready var label = $Label
onready var animation_player = $AnimationPlayer


func _ready():
	yield(get_parent(), "ready")


func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

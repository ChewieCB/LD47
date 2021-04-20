extends Spell
class_name Chain


func _ready():
	animation_player.play("default")
	randomize()
	# Rotate the chain in an interesting direction
	rotation_angle = rand_range(0, 2 * PI)
	self.rotate(rotation_angle)
	
	# Use this rotation to set a movement axis
	# TODO


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "break":
		queue_free()

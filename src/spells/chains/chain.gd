extends Node2D
class_name Chain

export (int) var number_of_inputs = 5

enum POSSIBLE_INPUTS {
	UP,
	RIGHT,
	DOWN,
	LEFT,
}

const INPUT_STRINGS = [
	"ui_up",
	"ui_right",
	"ui_down",
	"ui_left",
]

var input_sequence = []
var input_sequence_strings = []
var rotation_angle

onready var animation_player = $AnimationPlayer


func _init():
	# Generate a new pattern of user inputs
	for input in number_of_inputs:
		var random_input_index = randi() % POSSIBLE_INPUTS.size()
		input_sequence.append(POSSIBLE_INPUTS.keys()[random_input_index])
		input_sequence_strings.append(INPUT_STRINGS[random_input_index])


func _ready():
	animation_player.play("default")
	randomize()
	# Rotate the chain in an interesting direction
	rotation_angle = rand_range(0, 2*PI)
	self.rotate(rotation_angle)
	
	# Use this rotation to set a movement axis
	# TODO


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "break":
		queue_free()

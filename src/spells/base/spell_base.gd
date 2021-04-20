extends Node2D
class_name Spell

export (int) var number_of_inputs = 5
# Set which type of inputs can be generated
export (bool) var has_directional = true
export (bool) var has_duality = false
export (bool) var has_extra = false

enum DIRECTIONAL_INPUTS {
	UP,
	RIGHT,
	DOWN,
	LEFT,
}

enum DUALITY_INPUTS {
	W,
	D,
	S,
	A
}

enum EXTRA_INPUTS {
	Z,
	X,
}

const DIRECTIONAL_INPUT_STRINGS = [
	"input_up",
	"input_right",
	"input_down",
	"input_left",
]

const DUALITY_INPUT_STRINGS = [
	"duality_up",
	"duality_right",
	"duality_down",
	"duality_left",
]

const EXTRA_INPUT_STRINGS = [
	"input_z",
	"input_x",
]


var input_sequence = []
var input_sequence_strings = []
var rotation_angle

onready var animation_player = $AnimationPlayer


func _init():
	var POSSIBLE_INPUTS = []
	var POSSIBLE_INPUT_STRINGS = []
	# Determine which inputs to add
	if has_directional:
		POSSIBLE_INPUTS += DIRECTIONAL_INPUTS.keys()
		POSSIBLE_INPUT_STRINGS += DIRECTIONAL_INPUT_STRINGS
	if has_duality:
		POSSIBLE_INPUTS += DUALITY_INPUTS.keys()
		POSSIBLE_INPUT_STRINGS += DUALITY_INPUT_STRINGS
	if has_extra:
		POSSIBLE_INPUTS += EXTRA_INPUTS.keys()
		POSSIBLE_INPUT_STRINGS += EXTRA_INPUT_STRINGS
	# Generate a new pattern of user inputs
	for input in number_of_inputs:
		var random_input_index = randi() % POSSIBLE_INPUTS.size()
		input_sequence.append(POSSIBLE_INPUTS[random_input_index])
		input_sequence_strings.append(POSSIBLE_INPUT_STRINGS[random_input_index])



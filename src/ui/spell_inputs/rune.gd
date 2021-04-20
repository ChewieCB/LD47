extends Control

enum POSSIBLE_INPUTS {
	UP,
	RIGHT,
	DOWN,
	LEFT,
}

const INPUT_DIRECTIONS = [
	-90,
	0,
	90,
	180,
]

var input = POSSIBLE_INPUTS.RIGHT


func _ready():
	randomize()
	# Rotate the sprite to match the input direction
	$SpriteNormal.rotate(deg2rad(INPUT_DIRECTIONS[input]))
	$SpriteWin.rotate(deg2rad(INPUT_DIRECTIONS[input]))
	$SpriteFail.rotate(deg2rad(INPUT_DIRECTIONS[input]))
	$AnimationPlayer.play("default")


func correct_input():
	# TODO
	pass


func incorrect_input():
	# TODO
	pass
